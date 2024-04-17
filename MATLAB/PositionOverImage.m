t = [1: length(accelY)]*0.099; %Multiply by sampling frequency
yaw_error = yaw-yaw_des;

%{
figure(1); 
map = imread('Image.png'); %REPLACE WITH IMAGE NAME 
%map2 = flipud(map); %Possibly not necessary/ we'll have to figure this out in lab with image
subplot(2,1,1);
imshow(map);

hold on 
subplot(2,1,2)
xshift= x;
yshift = y;
plot(xshift,yshift,'-',"linewidth",5)
xlabel("X Position [m]")
ylabel("Y Position [m]")
title("Path Overlayed on Image")
grid on;

figure(2)
geoplot(lat(4:end),lon(4:end), "LineWidth",5)
geobasemap satellite
xlabel("X Position [m]")
ylabel("Y Position [m]")
title("Path Overlayed on Image")
grid on;
%axis equal;
%}

figure(2);
%Yaw Error Plot
subplot(2,1,1);
plot(t, yaw_error)
xlabel("Time [s]")
ylabel("Yaw Error [rad]")
title("Time vs. Yaw Error")


%Control effort vs. Time Plot 
%u is our control effort from P control in SurfaceControl.cpp
subplot(2,1,2);
plot(t,u)
xlabel("Time [s]")
ylabel("Control Effort [UNITS?]")
title("Time vs. Control Effort")
%}