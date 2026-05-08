%% run_timeseries_correction.m
% GNSS time-series correction and generation of .COR products.
%
% This script reads daily GNSS position time series in *.series format,
% fits a Nikolaidis-type model, and writes corrected .COR products.
%
% Expected event metadata:
%   metadata/events.csv with columns: station,time,type
% where time is decimal year and type is one of:
%   offset, instrument, earthquake
%
% Author: <your name>
% License: MIT or your preferred license

clear; clc;
%% ---------------- User settings ----------------
config.inputDir   = fullfile(pwd, 'data');       % folder containing *.series
config.figureDir  = fullfile(pwd, 'figures');    % diagnostic figures
config.eventFile  = fullfile(pwd, 'metadata', 'events.csv');
config.filePattern = '*.series';

% Time window in decimal years. Use [] to keep all available data.
config.startTime = [];
config.endTime   = [];

% Input coordinate scale. Original GipsyX *.series files are often in meters,
% so use 1000 to convert to mm. Use 1 if your input is already in mm.
config.positionScale = 1000;
config.sigmaScale    = 1000;

% Data filtering
config.minDataPoints = 30;
config.maxSigmaHorizontal = 10;   % mm; set [] to disable
config.maxSigmaVertical   = 30;   % mm; set [] to disable
config.outlierSigma = 3;          % iterative residual rejection threshold
config.nOutlierIterations = 1;

% Model settings
config.useAnnual      = true;
config.useSemiAnnual  = true;
config.modelPostseismic = true;
config.postseismicTauGrid = 0.20:0.05:1.00;  % years

% Plotting
config.makeFigure = false;

%% ---------------- Run ----------------
addpath(genpath(fullfile(pwd, 'functions')));

if ~exist(config.figureDir, 'dir'); mkdir(config.figureDir); end

files = dir(fullfile(config.inputDir, config.filePattern));
if isempty(files)
    error('No input files found: %s', fullfile(config.inputDir, config.filePattern));
end

fprintf('Found %d time-series files.\n', numel(files));

for i = 1:numel(files)
    infile = fullfile(files(i).folder, files(i).name);
    try
        result = process_station_series(infile, config);
        fprintf('[%d/%d] %s\n', i, numel(files), result.station);
        if config.makeFigure
            figfile = fullfile(config.figureDir, [result.station '_fit.png']);
            plot_timeseries_fit(result.series, result.fit, result.events, figfile);
        end
    catch ME
        fprintf('\nFAILED: %s\n', files(i).name);
        fprintf('%s\n', getReport(ME, 'extended', 'hyperlinks', 'off'));
    end
end
