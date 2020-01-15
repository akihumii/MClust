%% peak_to_trough_per_time
% code by luluwang 
% 20180518
%% 
clc;
clear all;
close all;
%%
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212');
load('data_wave1.mat'); 
load('data_ts1.mat');
load('data_spikeTime_tfile1'); 
% all spikes of month 1 
data_wave1 = permute(data_wave(:,1,:),[1,3,2]);
% find out the positive spikes of month 1
[same_data_time_positive1,location_data_ts_positive1,location_data_spikeTime_tfile1] = intersect(data_ts, data_spikeTime_tfile);
data_wave_positive_spikes1 = data_wave1(:,location_data_ts_positive1);

%% firing rate per spike positive : pixel interval
% got the number of positive peaks
[m1,n1]=size(data_wave_positive_spikes1);
location_positive_high1=zeros(n1,1);
location_positive_low1=zeros(n1,1);
% find the data and location of the peak and tough for total spikes respectively
for h=1:1:n1
 [data_wave_positive_spikes_H1, location_H1] = max(data_wave_positive_spikes1(:,h)); % high peak 
 [data_wave_positive_spikes_L1,location_L1] = min(data_wave_positive_spikes1(:,h)); % tough
 location_positive_high1(h)=location_H1;  % high peak location
 location_positive_low1(h)=location_L1;   % tough location
end

% the interval between peak and tough for each spikes
per_peak_interval_positive1 = abs(location_positive_low1-location_positive_high1).*3/32;   % 3 ms per spike, per index tome = 3/32 ms
% the mean of the interval
mean_per_peak_interval_positive1 = mean(per_peak_interval_positive1);
% std of the interval
std_per_peak_interval_positive1 = std(per_peak_interval_positive1);

cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212 saved data');
% save peak location
save('location_positive_high1', 'location_positive_high1'); 
% save tough location
save('location_positive_low1', 'location_positive_low1');
%%
% all spikes of month 2 
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212');
load('data_wave2.mat'); 
load('data_ts2.mat');
load('data_spikeTime_tfile2');
data_wave2 = permute(data_wave(:,1,:),[1,3,2]);
% find out the positive spikes of month 2 
[same_data_time_positive2,location_data_ts_positive2,location_data_spikeTime_tfile2] = intersect(data_ts, data_spikeTime_tfile);
data_wave_positive_spikes2 = data_wave2(:,location_data_ts_positive2);

%% firing rate per spike positive : pixel interval
[m2,n2]=size(data_wave_positive_spikes2);
location_positive_high2=zeros(n2,1);
location_positive_low2=zeros(n2,1);
for h=1:1:n2
 [data_wave_positive_spikes_H2, location_H2] = max(data_wave_positive_spikes2(:,h)); % high peak 
 [data_wave_positive_spikes_L2,location_L2] = min(data_wave_positive_spikes2(:,h)); % low peak
 location_positive_high2(h)=location_H2;
 location_positive_low2(h)=location_L2;
end
per_peak_interval_positive2 = abs(location_positive_low2-location_positive_high2).*3/32; % 3 ms
mean_per_peak_interval_positive2 = mean(per_peak_interval_positive2);
std_per_peak_interval_positive2 = std(per_peak_interval_positive2);

cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212 saved data');
% save peak location
save('location_positive_high2', 'location_positive_high2'); 
% save tough location
save('location_positive_low2', 'location_positive_low2');
%% 
% all spikes of month 3 
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212');
load('data_wave3.mat'); 
load('data_ts3.mat');
load('data_spikeTime_tfile3'); 
data_wave3 = permute(data_wave(:,1,:),[1,3,2]);
% find out the positive spikes of month 3
[same_data_time_positive3,location_data_ts_positive3,location_data_spikeTime_tfile3] = intersect(data_ts, data_spikeTime_tfile);
data_wave_positive_spikes3 = data_wave3(:,location_data_ts_positive3);

[m3,n3]=size(data_wave_positive_spikes3);
location_positive_high3=zeros(n3,1);
location_positive_low3=zeros(n3,1);
for h=1:1:n3
 [data_wave_positive_spikes_H3, location_H3] = max(data_wave_positive_spikes3(:,h)); % high peak 
 [data_wave_positive_spikes_L3,location_L3] = min(data_wave_positive_spikes3(:,h)); % low peak
 location_positive_high3(h)=location_H3;
 location_positive_low3(h)=location_L3;
end
per_peak_interval_positive3 = abs(location_positive_low3-location_positive_high3).*3/32; % 3 ms
mean_per_peak_interval_positive3 = mean(per_peak_interval_positive3);
std_per_peak_interval_positive3 = std(per_peak_interval_positive3);

cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212 saved data');
% save peak location
save('location_positive_high3', 'location_positive_high3'); 
% save tough location
save('location_positive_low3', 'location_positive_low3');
%% multi month values
% add another month value eg: [mean1 mean2 mean3...]
all_month_mean = [mean_per_peak_interval_positive1 mean_per_peak_interval_positive2 mean_per_peak_interval_positive3];
all_month_std = [std_per_peak_interval_positive1 std_per_peak_interval_positive2 std_per_peak_interval_positive3];
Time = 1:1:3; % 3 means the month you have
figure(17)
errorbar(Time,all_month_mean,all_month_std,'-or')
xlabel('time (month)');
xticks([1 2 3]);
ylabel('time interval between Peaks and troughs (ms)');
title('Peaks and troughs per time');





