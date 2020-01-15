%% interspike_interval_nspike
% code by luluwang 
% 20180518
%% 
clc;
clear all;
close all;
%%
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\0925cortexcluster1');
load('data_wave1.mat'); 
load('data_ts1.mat');
load('data_spikeTime_tfile1'); 
% all spikes of month 1 
data_wave1 = permute(data_wave(:,1,:),[1,3,2]);
% find out the positive spikes of month 1
[same_data_time_positive1,location_data_ts_positive1,location_data_spikeTime_tfile1] = intersect(data_ts, data_spikeTime_tfile);
data_wave_positive_spikes1 = data_wave1(:,location_data_ts_positive1);
%% fringe_per_time
[m1,n1]=size(data_wave_positive_spikes1);
%to get the interval time between two adjacent peaks
data_ts_interval_positive1 = diff(same_data_time_positive1); 
% save the data of the interval time between two adjacent peaks
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\0925cortex');
save('data_ts_interval_positive1','data_ts_interval_positive1');

%% plot
figure(4)
% internal 5 ms, 50 means 5 ms, you can change the interval as you want 
xbins1 = 0:50:10000;                         
%xbins1 = 100;                      % maximum internal = 3310/10 ms, if divided to 100,  means x-axis interval is 33/10 ms.  Plot a histogram of peaks numbers sorted into 100 equally spaced bins.
% I suggest you to read matlab hist for detail for better understanding
hist(data_ts_interval_positive1,xbins1);     
xlabel('xbins(1 msec)');
ylabel('number');                              
title('interspike interval nspike1');
xlim([0 9000]);


% in rate
figure(41)
% internal 5 ms, 50 means 5 ms, you can change the interval as you want 
xbins1 = 0:50:10000; 
%xbins1 = 100;  
[histFreq_positive1, histXout_positive1] = hist(data_ts_interval_positive1,xbins1);  
bar(histXout_positive1,histFreq_positive1/n1);
%bar(log10(histXout_positive1),histFreq_positive1/n1);
%set(gca,'xscale','log')
xlim([0 10000]);
xlabel('xbins(1 msec)');
ylabel('rate');
title('interspike interval frequncy');


