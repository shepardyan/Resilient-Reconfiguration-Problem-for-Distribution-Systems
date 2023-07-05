function [Pf, Qf, u, Pg, Qg, Pl, Ql, c, delta, epsilon] = resilient_reconfiguration(mpc, z)
% define constants for MATPOWER
define_constants;
[ref, ~, ~] = bustypes(mpc.bus, mpc.gen);
nb = size(mpc.bus, 1);
nl = size(mpc.branch, 1);
ngen = size(mpc.gen, 1);
nref = length(ref);
Plmax = mpc.bus(:, PD) ./ mpc.baseMVA;
Qlmax = mpc.bus(:, QD) ./ mpc.baseMVA;
genBus = mpc.gen(:, GEN_BUS);
loadBus = setdiff(mpc.bus(:, BUS_I), genBus);

% Initialize reconfiguration model
Pf = sdpvar(nl, 1);
Qf = sdpvar(nl, 1);
u = sdpvar(nb, 1);
Pg = sdpvar(ngen, 1);
Qg = sdpvar(ngen, 1);
Pl = sdpvar(nb, 1);
Ql = sdpvar(nb, 1);
c = binvar(nl, 1);       % Branch status
epsilon = binvar(nb, 1); % If energized by power sources
delta = binvar(nb, 1);   % If picked up
flow = sdpvar(nl, 1);    % Auxiliary variables for radial topology

% Initialize constraint list
constraints = [];

% Voltage of generators
constraints = [constraints, u(ref) == mpc.gen(:, VG) .^ 2];

% Voltage boundaries
constraints = [constraints, u <= mpc.bus(:, VMAX).^2, u >= mpc.bus(:, VMIN) .^ 2];

% Branch constraints
for i = 1:nl
    r = mpc.branch(i, BR_R);
    x = mpc.branch(i, BR_X);
    fbus = mpc.branch(i, F_BUS);
    tbus = mpc.branch(i, T_BUS);
    rate = mpc.branch(i, RATE_A) / mpc.baseMVA;
    M = 1000;                                                                % Sufficient large positive number
    constraints = [constraints, -M * (1 - c(i)) <= u(fbus) - u(tbus) - 2 * (r * Pf(i) + x * Qf(i)), u(fbus) - u(tbus) - 2 * (r * Pf(i) + x * Qf(i)) <= M * (1 - c(i))];
    constraints = [constraints, Pf(i) <= rate * c(i), Pf(i) >= -rate * c(i)];
    constraints = [constraints, Qf(i) <= rate * c(i), Qf(i) >= -rate * c(i)];
    constraints = [constraints, Pf(i) + Qf(i) <= sqrt(2) * rate * c(i), Qf(i) + Pf(i) >= -rate * sqrt(2) * c(i)];
    constraints = [constraints, Pf(i) - Qf(i) <= sqrt(2) * rate * c(i), Pf(i) - Qf(i) >= -rate * sqrt(2) * c(i)];
end

% Nodal active power balance
for i = 1:nb
    gen_num = find(mpc.gen(:, GEN_BUS) == i);
    from_branch = find(mpc.branch(:, F_BUS) == i);
    to_branch = find(mpc.branch(:, T_BUS) == i);
    if isempty(gen_num)
        if isempty(from_branch)
            if isempty(to_branch)
                constraints = [constraints, 0 == Pl(i)];
            else
                constraints = [constraints, sum(Pf(to_branch)) == Pl(i)];
            end
        else
            if isempty(to_branch)
                constraints = [constraints, -sum(Pf(from_branch)) == Pl(i)];
            else
                constraints = [constraints, -sum(Pf(from_branch)) + sum(Pf(to_branch)) == Pl(i)];
            end
        end
    else
        if isempty(from_branch)
            if isempty(to_branch)
                constraints = [constraints, 0 == Pl(i) - Pg(gen_num)];
            else
                constraints = [constraints, sum(Pf(to_branch)) == Pl(i) - Pg(gen_num)];
            end
        else
            if isempty(to_branch)
                constraints = [constraints, -sum(Pf(from_branch)) == Pl(i) - Pg(gen_num)];
            else
                constraints = [constraints, -sum(Pf(from_branch)) + sum(Pf(to_branch)) == Pl(i) - Pg(gen_num)];
            end
        end
    end
end

% Nodal reactive power balance
for i = 1:nb
    gen_num = find(mpc.gen(:, GEN_BUS) == i);
    from_branch = find(mpc.branch(:, F_BUS) == i);
    to_branch = find(mpc.branch(:, T_BUS) == i);
    if isempty(gen_num)
        if isempty(from_branch)
            if isempty(to_branch)
                constraints = [constraints, 0 == Ql(i)];
            else
                constraints = [constraints, sum(Qf(to_branch)) == Ql(i)];
            end
        else
            if isempty(to_branch)
                constraints = [constraints, -sum(Qf(from_branch)) == Ql(i)];
            else
                constraints = [constraints, -sum(Qf(from_branch)) + sum(Qf(to_branch)) == Ql(i)];
            end
        end
    else
        if isempty(from_branch)
            if isempty(to_branch)
                constraints = [constraints, 0 == Ql(i) - Qg(gen_num)];
            else
                constraints = [constraints, sum(Qf(to_branch)) == Ql(i) - Qg(gen_num)];
            end
        else
            if isempty(to_branch)
                constraints = [constraints, -sum(Qf(from_branch)) == Ql(i) - Qg(gen_num)];
            else
                constraints = [constraints, -sum(Qf(from_branch)) + sum(Qf(to_branch)) == Ql(i) - Qg(gen_num)];
            end
        end
    end
end

% Load constraints
constraints = [constraints, Pl == delta .* Plmax, Ql == delta .* Qlmax];


% Generation constraints
constraints = [constraints, Pg >= mpc.gen(:, PMIN) / mpc.baseMVA, Pg <= mpc.gen(:, PMAX) / mpc.baseMVA];
constraints = [constraints, Qg >= mpc.gen(:, QMIN) / mpc.baseMVA, Qg <= mpc.gen(:, QMAX) / mpc.baseMVA];

% Nodal pickup constraint
constraints = [constraints, delta >= epsilon, epsilon(genBus) == 1];  % Equation (A11) and (A12)
for i = 1:length(loadBus)
    lNode = loadBus(i);
    from_branch = find(mpc.branch(:, F_BUS) == lNode);
    jNodeFrom = mpc.branch(from_branch, T_BUS);
    to_branch = find(mpc.branch(:, T_BUS) == lNode);
    jNodeTo = mpc.branch(to_branch, F_BUS);
    brhNum = length(from_branch) + length(to_branch);
    constraints = [constraints, epsilon(lNode) <= sum(epsilon(jNodeFrom) .* c(from_branch)) + sum(epsilon(jNodeTo) .* c(to_branch)),...
                                      epsilon(lNode) >= (sum(epsilon(jNodeFrom) .* c(from_branch)) + sum(epsilon(jNodeTo) .* c(to_branch))) / brhNum];  % Equation (A13)
end


% Radiality constraints
constraints = [constraints, c <= z];                               % Spanning tree is constrained by attacker's decision
for i = 1:nl
    % Equation (3a) is eliminated using the compactness form f_{ij}^{-} = c_{ij} - f_{ij}^{+}
    constraints = [constraints, flow(i) >= ...                     % Equation (5)
        (1/(nb - nref + 1)) * c(i)];
    constraints = [constraints, c(i) - flow(i) >= ...              % Equation (5)
        (1/(nb - nref + 1)) * c(i)];
end

source_cons = [];
for i = 1:nb
    iIndexFrom = find(mpc.branch(:, F_BUS) == i);
    iIndexTo   = find(mpc.branch(:, T_BUS) == i);
    if i ~= ref
        constraints = [constraints, sum(flow(iIndexTo)) + ...       % Equation (3b)
            sum(c(iIndexFrom) - flow(iIndexFrom)) <= (nb - nref) / (nb - nref + 1)];
    else
        source_cons = [source_cons, sum(flow(iIndexTo)) + ...       % Equation (3c)
            sum(c(iIndexFrom) - flow(iIndexFrom))];
    end
end
constraints = [constraints, sum(source_cons) <= ...                 % Equation (3c)
    (nb - nref) / (nb - nref + 1)];
constraints = [constraints, flow >= 0];                             % Equation (3d)

% Set objective function
objective = sum((1 - delta) .* mpc.bus(:, PD) ./ mpc.baseMVA);

% Optimize reconfiguration problem
optimize(constraints, objective);
end