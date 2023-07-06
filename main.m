define_constants;
% take 33 bus distribution system as an example
mpc = IEEE33;
% Break lines setup
break_lines = [1];
z = ones(size(mpc.branch, 1), 1);
z(break_lines) = 0.;

% Optimization problem
[Pf, Qf, u, Pg, Qg, Pl, Ql, c, delta, epsilon] = resilient_reconfiguration(mpc, z);

% Visualization of load shedding
plot(value(Pl)); hold on; plot(mpc.bus(:, PD) ./ mpc.baseMVA); hold off;

% Visualization of topology
plotCase33(mpc.branch(:, BR_STATUS), z, value(c), mpc.gen(:, GEN_BUS), value(epsilon), value(delta));