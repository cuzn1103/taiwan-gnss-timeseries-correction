function plot_timeseries_fit(series, fit, events, outfile)
%PLOT_TIMESERIES_FIT Save diagnostic GNSS time-series fit figure.
%
% Black dots show retained data after 3-sigma outlier removal.
% Blue line shows the fitted model.

fig = figure('Visible','off', ...
    'Renderer','painters', ...
    'Position',[100 100 1000 700]);

components = {'N','E','U'};
ylabels = {'North (mm)','East (mm)','Up (mm)'};

t = series.time(:);
keep = fit.keep(:);

for i = 1:3
    c = components{i};

    subplot(3,1,i);

    y = series.(c)(:);
    model = fit.(c).fullModel(:);

    y0 = mean(y(keep),'omitnan');

    % 保留資料（黑）
    plot(t(keep), y(keep) - y0, 'ko', 'MarkerSize', 3, 'MarkerFaceColor', 'k'); 
    hold on;

    % 被刪掉的點（紅）
    % plot(t(~keep), y(~keep) - y0, 'r.', 'MarkerSize', 6);

    % model（藍線）
    plot(t, model - y0, '-', 'linewidth', 2, 'Color', [0.7 1 0.7]);

    ylabel(ylabels{i});
    grid on;
    xlim([floor(min(t)), ceil(max(t))]);

    if i < 3
        set(gca,'XTickLabel',[]);
    end

    draw_events(events);

    if i == 1
        title(series.station, 'Interpreter','none');
    end
end

xlabel('Time (decimal year)');

[folder, ~, ~] = fileparts(outfile);
if ~exist(folder, 'dir')
    mkdir(folder);
end

print(fig, outfile, '-dpng', '-r300');
close(fig);

end

function draw_events(events)

if isfield(events,'offset')
    for k = 1:numel(events.offset)
        xline(events.offset(k), '--', 'offset', ...
            'LabelOrientation','horizontal', ...
            'LabelVerticalAlignment','bottom');
    end
end

if isfield(events,'instrument')
    for k = 1:numel(events.instrument)
        xline(events.instrument(k), ':', 'inst.', ...
            'LabelOrientation','horizontal', ...
            'LabelVerticalAlignment','bottom');
    end
end

if isfield(events,'earthquake')
    for k = 1:numel(events.earthquake)
        xline(events.earthquake(k), '-', 'eq', ...
            'LabelOrientation','horizontal', ...
            'LabelVerticalAlignment','bottom');
    end
end

end