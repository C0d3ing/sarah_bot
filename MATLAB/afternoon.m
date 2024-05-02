clear;
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
length2 = verticalsize(1);

% assemble time rows
for i = 1:9:length2
    tunits = horzcat(tunits, datamatrix(i,:));
end

% assemble therm rows
for i = thermistor:9:length2
    therm = horzcat(therm, datamatrix(i,:));
end

% assemble salmax rows
for i = salinitymax:9:length2
    salmax = horzcat(salmax, datamatrix(i,:));
end

% assemble salmin rows
for i = salinitymin:9:length2
    salmin = horzcat(salmin, datamatrix(i,:));
end

% assemble anem rows
for i = anemometer:9:length2
    anem = horzcat(anem, datamatrix(i,:));
end

% convert from teensy units to time
time = (tunits-tunits(1))/1000000;

% thermistor calibration
temperatures = (therm*3.3/1024)*13.569 - 18.182;

% salinity calibration

salmax_v = salmax*3.3/1024*1000;
salmin_v = salmin*3.3/1024*1000;
salinitypk = ((salmax_v-salmin_v)); %in mV
salinity_c = (-5/262)*((sqrt(3098465 - 5240*salmax_v)) - 2035); %change the x
%salinity_c = (-5/122)*(sqrt(5)*sqrt(394021 - 488*salmax_v) - 1105);
% salinity_calibrationcurve = @(x) (-0.514*x.^2+40.4*x-199);
% for i = 1:45000
%     salinty_calibrated(i) = fsolve(salinity_calibrationcurve, salinity(i), optimset('MaxFunEvals',1000,'TolFun',1E-12,'MaxIter',1000,'Display','Off'));
% end
salinitymaxforplot = real(salinity_c);

%salinitymaxforplot = (salmax*3.3*1000/1024-366)/10.3;

% anemometer calibration
%Find the time rising edges occur
risEdgetime = [];
for i = 1:length(anem)-1
    if (anem(1,i) <= 0 && anem(1,i+1)>0)
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

%% plotting temp
% plot data
% figure(1)
% plot(time, temperatures);
% title("Temperature vs. Time");
% xlabel("Time (seconds)");
% ylabel("Temperature (degrees C)");
% time_start = 60; % Start time
% time_end = 129; % End time
% 
% % Find the indices corresponding to the time range of interest
% idx_range = time >= time_start & time <= time_end;
% 
% % Extract the data within the specified time range
% time_subset = time(idx_range);
% tempplot_subset = temperatures(idx_range);
% 
% 
% % Fit a best-fit line
% [Xout, Yout] = prepareCurveData(time_subset, tempplot_subset); 
% bestFit = fit(Xout, Yout, 'poly1'); % Linear (1st-order) fit
% 
% % Extract fitted line values
% xFit = linspace(min(Xout), max(Xout), 100); % Generate x values for the fitted line
% yFit = feval(bestFit, xFit); % Evaluate the fitted line at xFit
% 
% % Calculate confidence bounds
% confLev = 0.95; % Confidence level
% p11 = predint(bestFit, xFit, confLev, 'observation', 'off'); % Generate observational bounds
% p21 = predint(bestFit, xFit, confLev, 'functional', 'off'); % Generate functional bounds
% 
% % Plotting the original data, best-fit line, and bounds
% plot(time_subset, tempplot_subset, 'LineWidth', 1.5);
% hold on
% plot(xFit, yFit, 'k', 'LineWidth', 1.5);
% plot(xFit, p11, '--b') % Upper and lower functional confidence limits
% plot(xFit, p21, '--m') % Upper and lower observational confidence limits
% plot([min(time_subset), max(time_subset)], [17.5, 17.5], 'LineWidth', 1.5);
% legend('Raw Data','Best Fit Line', 'Upper Func. Bound','Lower Func. Bound', 'Upper Obs. Bound', 'Lower Obs. Bound','Expected Temperature','Location', 'northwest')
% 
% title("Temperature vs. Time, Afternoon", 'FontSize', 18);
% xlabel("Time (seconds)",'FontSize', 14);
% ylabel("Temperature (°C)",'FontSize', 14);
% xlim([60 129])
% ylim([14 18])
% grid on;
% hold off;
% avg= mean(yFit)
% uncertainty = mean(p11)

%%plotting wind
% figure(3)
% time = risEdgetime(1, 1:length(risEdgetime)-1)*0.0001;
% plot(time, windspeed,'LineWidth', 1.5);
% title("Windspeed vs. Time, Afternoon", 'FontSize', 14);
% xlabel("Time (seconds)", 'FontSize', 14);
% ylabel("Windspeed (m/s)", 'FontSize', 14);
% grid on
% 
% time_start = 60; % Start time
% time_end = 129; % End time
% 
% % Find the indices corresponding to the time range of interest
% idx_range = time >= time_start & time <= time_end;
% 
% % Extract the data within the specified time range
% time_subset = time(idx_range);
% windspeed_subset = windspeed(idx_range);
% 
% 
% % Fit a best-fit line
% [Xout, Yout] = prepareCurveData(time_subset, windspeed_subset); 
% bestFit = fit(Xout, Yout, 'poly3'); % Linear (1st-order) fit
% 
% % Extract fitted line values
% xFit = linspace(min(Xout), max(Xout), 100); % Generate x values for the fitted line
% yFit = feval(bestFit, xFit); % Evaluate the fitted line at xFit
% 
% % Calculate confidence bounds
% confLev = 0.95; % Confidence level
% p11 = predint(bestFit, xFit, confLev, 'observation', 'off'); % Generate observational bounds
% p21 = predint(bestFit, xFit, confLev, 'functional', 'off'); % Generate functional bounds
% 
% % Plotting the original data, best-fit line, and bounds
% figure
% plot(time_subset, windspeed_subset, 'LineWidth', 1.5);
% hold on
% plot(xFit, yFit, 'k', 'LineWidth', 1.5);
% plot(xFit, p11, '--b') % Upper and lower functional confidence limits
% plot(xFit, p21, '--m') % Upper and lower observational confidence limits
% plot([min(time_subset), max(time_subset)], [34.5, 34.5], 'LineWidth', 1.5);
% legend('Raw Data','Best Fit Line', 'Upper Obs. Bound','Lower Obs. Bound', 'Upper Func. Bound', 'Lower Func. Bound','Expected Salinity')
% xlabel("Time (seconds)", 'FontSize', 14);
% ylabel("Salinity (ppt)", 'FontSize', 14);
% title("Salinity (Pk-Pk Output) vs. Time in Water, Afternoon", 'FontSize', 18);
% grid on;
% hold off;
% avg= mean(yFit)
% uncertainty = mean(p11)


%% plotting salinity 
% %-----plotting salinity max and min voltage output 
% figure(4)
% plot(time, salmax_v,'LineWidth', 1.5);
% hold on
% plot(time, salmin_v,'LineWidth', 1.5);
% title("Salinity Max and Min Output vs. Time, Afternoon", 'FontSize', 14);
% xlabel("Time (seconds)", 'FontSize', 14);
% ylabel("Voltage (mV)", 'FontSize', 14);
% legend("Maximum Detector", "Minimum Detector");
% xlim([10 200]);
% grid on;
% ax = gca; 
% ax.FontSize = 14; 
% ax.XAxis.Label.FontSize = 14; 
% ax.YAxis.Label.FontSize = 14;
% set(gca,'Color','white')
% 
% fitline = fit(time.', salmin_v.', 'poly1');
% xdata = linspace(min(time), max(time), 100);
% ydata = feval(fitline, xdata);
% plot(xdata, ydata, 'k', 'LineWidth', 1.5, 'DisplayName', 'Fitted Line');
% 
% confLev = 0.95;
% [Xout,Yout] = prepareCurveData(time, salmin_v); 
% [f,stat] = fit(Xout,Yout,'poly1'); % 1st-order fit with statistics.
% p1 = predint(f,xdata,confLev,'observation','off'); % Gen conf bounds
% p2 = predint(f,xdata,confLev,'functional','off'); % Gen conf bounds
% plot(xdata, p1, '--b') % Upper and lower functional confidence limits
% plot(xdata, p2, '--m') % Upper and lower observational confidence limits
% legend('Raw Data','Best Fit Line', 'Upper Func. Bound','Lower Func. Bound', 'Upper Obs. Bound', 'Lower Obs. Bound',...
%     'Location', 'northwest')
% avg_fitline = mean(ydata);
% uncertainty = mean(p1);

% %-----plotting salinity output with max 
% Plotting the original data
time_start = 60; % Start time
time_end = 129; % End time

% Find the indices corresponding to the time range of interest
idx_range = time >= time_start & time <= time_end;

% Extract the data within the specified time range
time_subset = time(idx_range);
salinitymaxforplot_subset = salinitymaxforplot(idx_range);


% Fit a best-fit line
[Xout, Yout] = prepareCurveData(time_subset, salinitymaxforplot_subset); 
bestFit = fit(Xout, Yout, 'poly2'); % Linear (1st-order) fit

% Extract fitted line values
xFit = linspace(min(Xout), max(Xout), 100); % Generate x values for the fitted line
yFit = feval(bestFit, xFit); % Evaluate the fitted line at xFit

% Calculate confidence bounds
confLev = 0.95; % Confidence level
p11 = predint(bestFit, xFit, confLev, 'observation', 'off'); % Generate observational bounds
p21 = predint(bestFit, xFit, confLev, 'functional', 'off'); % Generate functional bounds

% Plotting the original data, best-fit line, and bounds
figure
plot(time_subset, salinitymaxforplot_subset, 'LineWidth', 1.5);
hold on
plot(xFit, yFit, 'k', 'LineWidth', 1.5);
plot(xFit, p11, '--b') % Upper and lower functional confidence limits
plot(xFit, p21, '--m') % Upper and lower observational confidence limits
plot([min(time_subset), max(time_subset)], [34.5, 34.5], 'LineWidth', 1.5);



%legend('Raw Data','Best Fit Line', 'Upper Obs. Bound','Lower Obs. Bound', 'Upper Func. Bound', 'Lower Func. Bound','Expected Salinity', 'First-Order Response')

legend('Raw Data','Best Fit Line', 'Upper Obs. Bound','Lower Obs. Bound', 'Upper Func. Bound', 'Lower Func. Bound','Expected Salinity')
xlabel("Time (seconds)", 'FontSize', 14);
ylabel("Salinity (ppt)", 'FontSize', 14);
title("Salinity (Pk-Pk Output) vs. Time in Water, Afternoon", 'FontSize', 18);
grid on;
hold off;
xlim([60 129])
ylim([0 40])
avg= mean(yFit)
uncertainty = mean(p11)




