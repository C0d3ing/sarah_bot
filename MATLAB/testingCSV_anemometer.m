% read in csv file
ds = tabularTextDatastore('hello29.csv','TreatAsMissing','NA','MissingValue',0);
data = read(ds);
datamatrix = table2array(data);

%21 is morning run
%29 is afternoon run

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
%Find the time rising edges occur
risEdgetime = [];
for i = 1:length(anem)-1
    if (anem(1,i) <= 1 && anem(1,i+1)>0)
        risEdgetime = [risEdgetime time(i)];
    end
end
%Find the periods between rising edges
anemPeriods = [];
for i = 1:(length(risEdgetime)-1)
    anemPeriods = [anemPeriods (risEdgetime(i+1) - risEdgetime(i))];
end
%convert periods using calibration curve
windspeed = anemPeriods*0.0001 * -8.03 + 8.74;

% plot data
plot(risEdgetime(1, 1:length(risEdgetime)-1)*0.01, windspeed,'LineWidth',1.5);
hold on
plot(risEdgetime(1, 1:length(risEdgetime)-1)*0.01, windspeed,"bx")
title("Windspeed vs Time, 2pm")
ylabel("Windspeed [mph]")
xlabel("Time [s]")
fontsize(12, "points")
hold on

%confidence bounds

[p,s] = polyfit(risEdgetime(1, 1:length(risEdgetime)-1)*0.0001, windspeed, 1);

[yfit, dy] = polyconf(p,risEdgetime(1, 1:length(risEdgetime)-1)*0.0001, s, "predopt","curve" );

%plot the fit curve
line(risEdgetime(1, 1:length(risEdgetime)-1)*0.01, yfit)

%upper bound
line(risEdgetime(1, 1:length(risEdgetime)-1)*0.01, yfit-dy,"color","r","linestyle", ":",'LineWidth',1.5)

%lower bound
line(risEdgetime(1, 1:length(risEdgetime)-1)*0.01, yfit+dy,"color","r","linestyle", ":",'LineWidth',1.5)

axis([60 130 6 9])

legend("Averages","Measured Points" , "Fit Curve", "Lower Confidence Bound", "Upper Confidence Bound");
