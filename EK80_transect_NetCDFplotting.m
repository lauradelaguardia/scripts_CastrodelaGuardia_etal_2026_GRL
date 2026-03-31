clearvars
clc
close all

ncfilename='EK80_18kHz_transect_RosenborgWest.nc';
 sv = double(ncread(ncfilename,'sv'));
 depth    = double(ncread(ncfilename,'depth')); %m
timetag  = ncread(ncfilename,'time')';% km along the merged glacier front section 
  
% Variables "sv", "time" and "depth" come from: Match filtering and basic
% processing applied to sonar's raw data using internal scripts provided by L.
% Andersen (Kongsberg Discovery). Data are not calibrated and depth is
% calculated with a transducer draft of 7 m and a sound speed of
% 1500 m/s.

figure(1)
pcolor(timetag,depth,sv), axis ij, shading flat
datetick('x','HH:MM','keeplimits','keepticks')
set(gca,'ticklength',[0.01, 0.01])
ylim([0 210])
title({'Simrad EK80, CW 18 kHz';['date: ',datestr(timetag(100),'yyyy-mm-dd')]})
clim([-90 -65])
ylabel('Depth [m]')
xlabel('Time [hour:minute]')
h = colorbar;
ylabel(h,'Uncorrected sound pressure [dB]','rotation',270,'FontSize',20)
set(findall(gcf,'-property','FontSize'),'FontSize',20)