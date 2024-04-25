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
tunits = [];
therm = [];
salmax = [];
salmin = [];
anem = [];
verticalsize = size(datamatrix);
length = verticalsize(1);

% assemble time rows
for i = 1:9:length
    tunits = horzcat(tunits, datamatrix(i,:));
end

% assemble therm rows
for i = thermistor:9:length
    therm = horzcat(therm, datamatrix(i,:));
end

% assemble salmax rows
for i = salinitymax:9:length
    salmax = horzcat(salmax, datamatrix(i,:));
end

% assemble salmin rows
for i = salinitymin:9:length
    salmin = horzcat(salmin, datamatrix(i,:));
end

% assemble anem rows
for i = anemometer:9:length
    anem = horzcat(anem, datamatrix(i,:));
end

% convert from teensy units to time
time = (tunits-12777542)/10000;

% thermistor calibration
temperatures = (therm*3.3/1024)*13.569 - 18.182;

% salinity calibration
salinity = (((salmax-salmin)*3.3/1024*1000)-104)/20.9;

%% anemometer calibration

%find the time rising edges occure
risEdgetime = [];
for i = 2:length(anem)
    if (anem(i-1) == 0 && anem(i)>0)
        risEdgetime = [risEdgetime time(i)];
    end
end

%Find the periods between rising edges
anemPeriods = [];
for i = 1:(length(risEdgetime)-1)
    anemPeriods = [anemPeriods (risEdgetime(i+1) - risEdgetime(i))];
end

%convert periods using calibration curve
windspeed = anemPeriods * -8.03 +8.74;

% plot data
plot(time, windspeed);
