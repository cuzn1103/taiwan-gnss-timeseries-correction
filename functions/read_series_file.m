function series = read_series_file(infile, config)
%READ_SERIES_FILE Read GNSS *.series file.
%
% Expected columns:
%   1 time(decimal year)
%   2 E
%   3 N
%   4 U
%   5 sigmaE
%   6 sigmaN
%   7 sigmaU

A = readmatrix(infile, 'FileType', 'text');

if size(A,2) < 4
    error('Input file must contain at least 4 columns: time E N U.');
end

if isfield(config,'positionScale') && isnumeric(config.positionScale)
    positionScale = config.positionScale;
else
    positionScale = 1;
end

if isfield(config,'sigmaScale') && isnumeric(config.sigmaScale)
    sigmaScale = config.sigmaScale;
else
    sigmaScale = positionScale;
end

[~, sta, ~] = fileparts(infile);

series.station = sta;
series.time = A(:,1);
series.E = A(:,2) * positionScale;
series.N = A(:,3) * positionScale;
series.U = A(:,4) * positionScale;

if size(A,2) >= 7
    series.sigmaE = A(:,5) * sigmaScale;
    series.sigmaN = A(:,6) * sigmaScale;
    series.sigmaU = A(:,7) * sigmaScale;
else
    series.sigmaE = nan(size(series.time));
    series.sigmaN = nan(size(series.time));
    series.sigmaU = nan(size(series.time));
end

% Time window
idx = true(size(series.time));

if isfield(config,'startTime') && ~isempty(config.startTime)
    idx = idx & series.time >= config.startTime;
end

if isfield(config,'endTime') && ~isempty(config.endTime)
    idx = idx & series.time <= config.endTime;
end

% Sigma filtering
if isfield(config,'maxSigmaHorizontal') && ~isempty(config.maxSigmaHorizontal)
    idx = idx & series.sigmaE <= config.maxSigmaHorizontal ...
              & series.sigmaN <= config.maxSigmaHorizontal;
end

if isfield(config,'maxSigmaVertical') && ~isempty(config.maxSigmaVertical)
    idx = idx & series.sigmaU <= config.maxSigmaVertical;
end

fields = fieldnames(series);
for k = 1:numel(fields)
    val = series.(fields{k});
    if isnumeric(val) && numel(val) == numel(idx)
        series.(fields{k}) = val(idx);
    end
end

if numel(series.time) < config.minDataPoints
    error('Not enough data points after filtering: %d', numel(series.time));
end

end