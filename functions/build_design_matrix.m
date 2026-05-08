function [G, terms] = build_design_matrix(t, events, config, tau)
%BUILD_DESIGN_MATRIX Build GNSS time-series design matrix.
% First output must be numeric matrix G.

t = t(:);
n = numel(t);

t0 = mean(t,'omitnan');
dt = t - t0;

G = [];
terms = struct('name', {});

G = [G, ones(n,1)];
terms(end+1).name = 'constant';

G = [G, dt];
terms(end+1).name = 'linear';

if config.useAnnual
    G = [G, cos(2*pi*t), sin(2*pi*t)];
    terms(end+1).name = 'annual_cos';
    terms(end+1).name = 'annual_sin';
end

if config.useSemiAnnual
    G = [G, cos(4*pi*t), sin(4*pi*t)];
    terms(end+1).name = 'semiannual_cos';
    terms(end+1).name = 'semiannual_sin';
end

for k = 1:numel(events.offset)
    G = [G, double(t > events.offset(k))];
    terms(end+1).name = 'offset_step';
end

for k = 1:numel(events.instrument)
    G = [G, double(t > events.instrument(k))];
    terms(end+1).name = 'instrument_step';
end

for k = 1:numel(events.earthquake)
    G = [G, double(t > events.earthquake(k))];
    terms(end+1).name = 'earthquake_step';
end

if config.modelPostseismic && ~isempty(tau)
    for k = 1:numel(events.earthquake)
        if k <= numel(tau) && isfinite(tau(k))
            dt_eq = t - events.earthquake(k);
            post = (1 - exp(-dt_eq ./ tau(k))) .* double(dt_eq > 0);
            G = [G, post];
            terms(end+1).name = 'postseismic';
        end
    end
end

if isstruct(G)
    error('Internal error: G is struct. build_design_matrix first output must be numeric.');
end

end