# Resilient Reconfiguration Problem for Distribution Systems

## Code usage

```MATLAB
% Break lines setup
break_lines = [3, 5, 7];

% Branch status setup
z = ones(size(mpc.branch, 1), 1);
z(break_lines) = 0.;

% Solve resilient reconfiguration problem
[Pf, Qf, u, Pg, Qg, Pl, Ql, c] = resilient_reconfiguration(mpc, z);
```

## Visualization

A visualization function **only** for **IEEE 33 bus distribution system** is defined in `plotCase33.m`.

## Note for casedata (MATPOWER mpc)

Branch power flow limits are set based on `RATE_A` column. If your casefile do not provide `RATE_A` data, please delete branch power flow limit constraints.

## Mathematical Model

Please refer to [1]'s appendix for overall mathematical model of this problem.

## Requirements

[1] R. D. Zimmerman, C. E. Murillo-Sanchez (2020). MATPOWER (Version 7.1) [Software]. Available: https://matpower.org

[2] Lofberg J. YALMIP: A toolbox for modeling and optimization in MATLAB[C]//2004 IEEE international conference on robotics and automation (IEEE Cat. No. 04CH37508). IEEE, 2004: 284-289. Available: https://yalmip.github.io/

[3] Any mixed-integer linear programming (MILP) solver.

## Reference

[1] S. Sun, G. Li, C. Chen, Y. Bian, and Z. Bie, “A Novel Formulation of Radiality Constraints for Resilient Reconfiguration of Distribution Systems,” IEEE Transactions on Smart Grid, vol. 14, no. 2, pp. 1337–1340, Mar. 2023, [doi: 10.1109/TSG.2022.3220054](https://doi.org/10.1109/TSG.2022.3220054).