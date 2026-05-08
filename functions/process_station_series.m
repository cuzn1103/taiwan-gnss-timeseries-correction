function result = process_station_series(infile, config)
%PROCESS_STATION_SERIES Read, model, and fit one GNSS time series.

series = read_series_file(infile, config);
events = read_station_events(series.station, config.eventFile);
fit = fit_gnss_timeseries(series, events, config);

result.station = series.station;
result.infile  = infile;
result.series  = series;
result.events  = events;
result.fit     = fit;

end