function plotCase33(initial_status, z, c, genBus, energized, picked)
branch = [
    1	2	0.0922	0.0470	0	4.60	4.60	4.60	0	0	1	-360	360
    2	3	0.4930	0.2511	0	4.10	4.10	4.10	0	0	1	-360	360
    3	4	0.3660	0.1864	0	2.90	2.90	2.90	0	0	1	-360	360
    4	5	0.3811	0.1941	0	2.90	2.90	2.90	0	0	1	-360	360
    5	6	0.8190	0.7070	0	2.90	2.90	2.90	0	0	1	-360	360
    6	7	0.1872	0.6188	0	1.50	1.50	1.50	0	0	1	-360	360
    7	8	0.7114	0.2351	0	1.05	1.05	1.05	0	0	1	-360	360
    8	9	1.0300	0.7400	0	1.05	1.05	1.05	0	0	1	-360	360
    9	10	1.0440	0.7400	0	1.05	1.05	1.05	0	0	1	-360	360
    10	11	0.1966	0.0650	0	1.05	1.05	1.05	0	0	1	-360	360
    11	12	0.3744	0.1238	0	1.05	1.05	1.05	0	0	1	-360	360
    12	13	1.4680	1.1550	0	0.50	0.50	0.50	0	0	1	-360	360
    13	14	0.5416	0.7129	0	0.45	0.45	0.45	0	0	1	-360	360
    14	15	0.5910	0.5260	0	0.30	0.30	0.30	0	0	1	-360	360
    15	16	0.7463	0.5450	0	0.25	0.25	0.25	0	0	1	-360	360
    16	17	1.2890	1.7210	0	0.25	0.25	0.25	0	0	1	-360	360
    17	18	0.7320	0.5740	0	0.10	0.10	0.10	0	0	1	-360	360
    2	19	0.1640	0.1565	0	0.50	0.50	0.50	0	0	1	-360	360
    19	20	1.5042	1.3554	0	0.50	0.50	0.50	0	0	1	-360	360
    20	21	0.4095	0.4784	0	0.21	0.21	0.21	0	0	1	-360	360
    21	22	0.7089	0.9373	0	0.11	0.11	0.11	0	0	1	-360	360
    3	23	0.4512	0.3083	0	1.05	1.05	1.05	0	0	1	-360	360
    23	24	0.8980	0.7091	0	1.05	1.05	1.05	0	0	1	-360	360
    24	25	0.8960	0.7011	0	0.50	0.50	0.50	0	0	1	-360	360
    6	26	0.2030	0.1034	0	1.50	1.50	1.50	0	0	1	-360	360
    26	27	0.2842	0.1447	0	1.50	1.50	1.50	0	0	1	-360	360
    27	28	1.0590	0.9337	0	1.50	1.50	1.50	0	0	1	-360	360
    28	29	0.8042	0.7006	0	1.50	1.50	1.50	0	0	1	-360	360
    29	30	0.5075	0.2585	0	1.50	1.50	1.50	0	0	1	-360	360
    30	31	0.9744	0.9630	0	0.50	0.50	0.50	0	0	1	-360	360
    31	32	0.3105	0.3619	0	0.50	0.50	0.50	0	0	1	-360	360
    32	33	0.3410	0.5302	0	0.10	0.10	0.10	0	0	1	-360	360

    % For a radial topology, the following tie-lines are breaked

    8	21	2.0000	2.0000	0	0.50	0.50	0.50	0	0	1	-360	360
    9	15	2.0000	2.0000	0	0.50	0.50	0.50	0	0	1	-360	360
    12	22	2.0000	2.0000	0	0.50	0.50	0.50	0	0	1	-360	360
    18	33	0.5000	0.5000	0	0.50	0.50	0.50	0	0	1	-360	360
    25	29	0.5000	0.5000	0	0.10	0.10	0.10	0	0	1	-360	360
    ];

f = branch(:, 1);
t = branch(:, 2);
XData = zeros(33, 1);
YData = zeros(33, 1);

row_1 = [-1, 23, 24, 25, -1, -1, 29, 30, 31, 32, 33];
row_2 = [1, -1, 5, 6, 26, 27, 28, -1, -1, -1, -1];
row_3 = [2, 3, 4, 7, 8, 9, 10, 11, 14, 15, 18];
row_4 = [19, 20, 21, -1, 22, -1, -1, 12, 13, 16, 17];
x_set = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27];


for i = 1:length(row_1)
    if row_1(i) > 0
        XData(row_1(i)) = x_set(i);
        YData(row_1(i)) = 5;
    end
    if row_2(i) > 0
        XData(row_2(i)) = x_set(i);
        YData(row_2(i)) = 3;
    end
    if row_3(i) > 0
        XData(row_3(i)) = x_set(i);
        YData(row_3(i)) = 1;
    end
    if row_4(i) > 0
        XData(row_4(i)) = x_set(i);
        YData(row_4(i)) = -1;
    end
end

figure('Position', [100, 100, 800, 500]);
hold on;


% Draw edges
for i = 1:size(branch, 1)
    node1 = branch(i, 1);
    node2 = branch(i, 2);
    x1 = XData(node1);
    y1 = YData(node1);
    x2 = XData(node2);
    y2 = YData(node2);

    % if a line is break
    ifMarker = false;
    % if a line is closed after reconfiguration
    ifClose = false;
    % if a line is opened after reconfiguration
    ifOpen = false;


    if z(i) == 1 && c(i) == 1 && initial_status(i) == 1
        line_spec = "-";
        color = 'black';
    elseif z(i) == 1 && c(i) == 1 && initial_status(i) == 0
        line_spec = "-";
        color = 'black';
        ifClose = true;
    elseif z(i) == 1 && c(i) == 0
        line_spec = "--";
        color = [0.5, 0.5, 0.5];
        ifOpen = true;
    elseif z(i) == 0
        line_spec = "--";
        color = [1 0 0];
        ifMarker = true;
    end
    if node1 == 9 && node2 == 15
        % Modify edge position to avoid overlapping
        y1prime = y1 + 1;
        y2prime = y2 + 1;
        plot([x1, x2], [y1prime, y2prime], line_spec, 'Color', color);
        plot([x1, x1], [y1, y1prime], line_spec, 'Color', color);
        plot([x2, x2], [y1, y1prime], line_spec, 'Color', color);
        if ifMarker
            scatter(mean([x1, x2]), mean([y1prime, y2prime]), 100, 'x', 'MarkerEdgeColor',[1,0,0]);
        end
        if ifOpen
            scatter(mean([x1, x2]), mean([y1prime, y2prime]), 100, 's', 'MarkerEdgeColor',[0,1,0], 'MarkerFaceColor','none');
        end
        if ifClose
            scatter(mean([x1, x2]), mean([y1prime, y2prime]), 100, 's', 'MarkerEdgeColor',[0,1,0], 'MarkerFaceColor',[0,1,0]);
        end

    elseif node1 == 8 && node2 == 21
        % Modify edge position to avoid overlapping
        plot([x1, x1], [y1, mean([y1, y2])], line_spec, 'Color', color);
        plot([x1, x2], [mean([y1, y2]), mean([y1, y2])], line_spec, 'Color', color);
        plot([x2, x2], [mean([y1, y2]), y2], line_spec, 'Color', color);
        if ifMarker
            scatter(mean([x1, x2]), mean([mean([y1, y2]), mean([y1, y2])]), 100, 'x', 'MarkerEdgeColor',[1,0,0]);
        end
        if ifOpen
            scatter(mean([x1, x2]), mean([mean([y1, y2]), mean([y1, y2])]), 100, 's', 'MarkerEdgeColor',[0,1,0], 'MarkerFaceColor','none');
        end
        if ifClose
            scatter(mean([x1, x2]), mean([mean([y1, y2]), mean([y1, y2])]), 100, 's', 'MarkerEdgeColor',[0,1,0], 'MarkerFaceColor',[0,1,0]);
        end
    else
        plot([x1, x2], [y1, y2], line_spec, 'Color', color);
        if ifMarker
            scatter(mean([x1, x2]), mean([y1, y2]), 100, 'x', 'MarkerEdgeColor',[1,0,0]);
        end
        if ifOpen
            scatter(mean([x1, x2]), mean([y1, y2]), 100, 's', 'MarkerEdgeColor',[0,1,0], 'MarkerFaceColor','none');
        end
        if ifClose
            scatter(mean([x1, x2]), mean([y1, y2]), 100, 's', 'MarkerEdgeColor',[0,1,0], 'MarkerFaceColor',[0,1,0]);
        end
    end
end

% Draw nodes
nodeSize = 50;
for i = 1:33
    if ismember(i, genBus)
        scatter(XData(i), YData(i), nodeSize, 'r^', 'filled');
    else
        if energized(i) > 0.5 && picked(i) > 0.5
            scatter(XData(i), YData(i), nodeSize, 'filled', 'MarkerFaceColor', [0, 1, 0]);
        elseif energized(i) > 0.5 && picked(i) < 0.5
            scatter(XData(i), YData(i), nodeSize, 'filled', 'MarkerFaceColor', [0, 0, 1]);
        else
            scatter(XData(i), YData(i), nodeSize, 'filled', 'MarkerFaceColor', 'black');
        end
    end
end

% Draw node labels
text(XData, YData, cellstr(num2str((1:numel(XData))')), 'FontSize', 13, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'FontName', 'Times New Roman');

hold off;
axis off;
end
