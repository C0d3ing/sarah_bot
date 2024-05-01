%windspeed
y = [3.626
4.187
4.681
5.128
5.539]';

%period
x = [0.652173913
0.5263157895
0.5084745763
0.46875
0.4054054054]';

manometerError = 0.4;

%error
C = 2*249.0884*(1/1.137)*0.01* (438.15)^(-0.5);
xerr = abs(C*x.^(-0.5)*manometerError);

errorbar(x,y,xerr, 'LineWidth',1.5,"LineStyle","none")
%R^2 value from google sheets
title("Windspeed vs Period, R^2 = 0.935")
ylabel("Windspeed [mph]")
xlabel("Period [s]")
fontsize(12, "points")

hold on

%plot regression

xr=linspace(0,0.65,100);
yr = xr*-8.03+8.74;
plot(xr,yr,'LineWidth',1.5)

legend("Measured points", "Linear Regression (-8.03x + 8.74)")

AverageError = sum(xerr)/length(xerr);
