function events = read_station_events(station, eventFile)
%READ_STATION_EVENTS Read station-specific events from metadata/events.csv.
%
% Expected columns:
%   station,time,type
%
% type:
%   offset, instrument, earthquake

if ~isfile(eventFile)
    error('Event file not found: %s', eventFile);
end

T = readtable(eventFile);

required = {'station','time','type'};
for i = 1:numel(required)
    if ~ismember(required{i}, T.Properties.VariableNames)
        error('events.csv must contain column: %s', required{i});
    end
end

sta = string(T.station);
typ = lower(string(T.type));
tim = T.time;

idx = strcmpi(sta, string(station));

events.offset     = tim(idx & typ == "offset");
events.instrument = tim(idx & typ == "instrument");
events.earthquake = tim(idx & typ == "earthquake");

events.offset     = events.offset(:);
events.instrument = events.instrument(:);
events.earthquake = events.earthquake(:);

end