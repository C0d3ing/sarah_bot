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
Mlength = verticalsize(1);

% assemble time rows
for i = 1:9:Mlength
    tunits = horzcat(tunits, datamatrix(i,:));
end

% assemble therm rows
for i = thermistor:9:Mlength
    therm = horzcat(therm, datamatrix(i,:));
end

% assemble salmax rows
for i = salinitymax:9:Mlength
    salmax = horzcat(salmax, datamatrix(i,:));
end

% assemble salmin rows
for i = salinitymin:9:Mlength
    salmin = horzcat(salmin, datamatrix(i,:));
end

% assemble anem rows
for i = anemometer:9:Mlength
    anem = horzcat(anem, datamatrix(i,:));
end

% convert from teensy units to time
time = (tunits-12777542)/10000;

% thermistor calibration
temperatures = (therm*3.3/1024)*13.569 - 18.182;

% salinity calibration
salinity = (((salmax-salmin)*3.3/1024*1000)-104)/20.9;

%% anemometer calibration

%Find the time rising edges occure
% risEdgetime = [];
% for i = 1:length(anem)-1
%     if (anem(1,i) < 1023 && anem(1,i+1) == 1023)
%         risEdgetime = [risEdgetime time(i)];
%     end
% end

%Find the time rising edges occure
risEdgetime = [];
for i = 1:length(anem)-1
    if (anem(1,i) <= 0 && anem(1,i+1) > 0)
        risEdgetime = [risEdgetime time(i)];
    end
end

%Find the periods between rising edges
%code for afternoon plot
anemPeriods = [];
for i = 1:(length(risEdgetime)-1)
    anemPeriods = [anemPeriods (risEdgetime(i+1) - risEdgetime(i))];
end

%convert periods using calibration curve
windspeed = anemPeriods*0.001 * -8.03 + 8.74;

%convert using frequency
%windspeed = anemPeriods.^(-1)*0.001 * 2.16 + 0.319;

% plot data
plot(risEdgetime(1, 1:length(risEdgetime)-1)*0.01, windspeed,'LineWidth',1.5);
title("Windspeed vs Time")
ylabel("Windspeedm [mph]")
xlabel("Time [s]")
fontsize(12, "points")

%code for morning plot

% if (length(anemPeriods)==0)
%     plot(time.*0.0001,zeros(1,length(time)))
%     title("Windspeed vs Time")
% ylabel("Windspeedm [m/s]")
% xlabel("Time [s]")
% fontsize(12, "points")
% 
% end
% 
% plot(1:400, zeros(1,400),'LineWidth',1.5)
% title("Windspeed vs Time")
% ylabel("Windspeedm [m/s]")
% xlabel("Time [s]")
% fontsize(12, "points")
