define_constants;
% take 33 bus distribution system as an example
mpc = IEEE33;

% Break lines setup
break_lines = [3, 5, 7];

z = ones(size(mpc.branch, 1), 1);
z(break_lines) = 0.;

[Pf, Qf, u, Pg, Qg, Pl, Ql, c] = resilient_reconfiguration(mpc, z);

plot(value(Pl)); hold on; plot(mpc.bus(:, PD) ./ mpc.baseMVA); hold off;

plotCase33(value(c));