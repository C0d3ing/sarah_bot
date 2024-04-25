% read in csv file
ds = tabularTextDatastore('hello29.csv','TreatAsMissing','NA','MissingValue',0);
data = read(ds);
datamatrix = table2array(data);

% define sensor variables
thermistor = 2;
salinitymin = 3;
salinitymax = 4;
anemometer = 5;

% define all needed rows
% read every [number] rows into single file of [number] rows
start = thermistor; % REPLACE! start is the row that the sensor of choice starts on!
time = [];
sensor = []; %RENAME to sensor of choice
verticalsize = size(datamatrix);
length = verticalsize(1);

% assemble time rows
for i = 1:9:length
    time = horzcat(time, datamatrix(i,:));
end

% assemble sensor rows
for i = start:9:length
    sensor = horzcat(sensor, datamatrix(i,:));
end

% thermistor calibration
temperatures = ;

% salinity calibration
salinity = ;

% anemometer calibration
windspeed = ;

% analyze data from new lists
plot(time, sensor);

