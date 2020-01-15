%% amplitude VS time/month
% code by luluwang 
% 20180518
%% 
clc;
clear all;
close all;
%% month 1
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212');
load('data_wave1.mat'); 
load('data_ts1.mat');
load('data_spikeTime_tfile1'); 
% all spikes of month 1 
data_wave1 = permute(data_wave(:,1,:),[1,3,2])
% find out the positive spikes of month 1
[same_data_time_positive1,location_data_ts_positive1,location_data_spikeTime_tfile1] = intersect(data_ts, data_spikeTime_tfile);
data_wave_positive_spikes1 = data_wave1(:,location_data_ts_positive1);
%% spikes number per 100 ms
[m1,n1]=size(data_wave_positive_spikes1);
start_time_positive1 = same_data_time_positive1(1);
temp_num_positive1 = zeros;
p=0;
q=0;
for o=1:1:n1  
    p=p+1;
    if(same_data_time_positive1(o)-start_time_positive1)>=20000   % judge peak numbers 1000 represent per 100ms     
       q=q+1;
       temp_num_positive1(q)=p;
       start_time_positive1 = same_data_time_positive1(o);
       p=0;
    end    
end  
% mean of spikes number per 1000 ms
 temp_num_positive1 =temp_num_positive1/2  %if time in line 26 is 20000, then here temp_num_positive1/(20000/10000) to get firing rate in unit of Hz
firing_rate_mean_positive1 = mean(temp_num_positive1); 
% std of spikes number per 1000 ms
firing_rate_std_positive1 = std(temp_num_positive1/2);
figure(8)
errorbar(firing_rate_mean_positive1,firing_rate_std_positive1,'-or')
% save data 
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212 saved data');
save('temp_num_positive1','temp_num_positive1');    % all
%% month 2
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212');
load('data_wave2.mat'); 
load('data_ts2.mat');
load('data_spikeTime_tfile2'); 
% all spikes of month 1 
data_wave2 = permute(data_wave(:,1,:),[1,3,2]);
% find out the positive spikes of month 1
[same_data_time_positive2,location_data_ts_positive2,location_data_spikeTime_tfile2] = intersect(data_ts, data_spikeTime_tfile);
data_wave_positive_spikes2 = data_wave2(:,location_data_ts_positive2);
%%
[m2,n2]=size(data_wave_positive_spikes2);
start_time_positive2 = same_data_time_positive2(1);
temp_num_positive2 = zeros;%((round(same_data_time_positive(end)- same_data_time_positive(1))/10)+1);
p=0;
q=0;
for o=1:1:n2  
    p=p+1;
    if(same_data_time_positive2(o)-start_time_positive2)>=20000       
       q=q+1;
       temp_num_positive2(q)=p;
       start_time_positive2 = same_data_time_positive2(o);
       p=0;
    end    
end
 temp_num_positive2 =temp_num_positive2/2
firing_rate_mean_positive2 = mean(temp_num_positive2);
firing_rate_std_positive2 = std(temp_num_positive2/2);
figure(9)
errorbar(firing_rate_mean_positive2,firing_rate_std_positive2,'-or')
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212 saved data');
save('temp_num_positive2','temp_num_positive2');

%% month 3
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212');
load('data_wave3.mat'); 
load('data_ts3.mat');
load('data_spikeTime_tfile3'); 
% all spikes of month 1 
data_wave3 = permute(data_wave(:,1,:),[1,3,2]);
% find out the positive spikes of month 1
[same_data_time_positive3,location_data_ts_positive3,location_data_spikeTime_tfile3] = intersect(data_ts, data_spikeTime_tfile);
data_wave_positive_spikes3 = data_wave3(:,location_data_ts_positive3);
%%
[m3,n3]=size(data_wave_positive_spikes3);
start_time_positive3 = same_data_time_positive3(1);
temp_num_positive3 = zeros;%((round(same_data_time_positive(end)- same_data_time_positive(1))/10)+1);
p=0;
q=0;
for o=1:1:n3  
    p=p+1;
    if(same_data_time_positive3(o)-start_time_positive3)>=20000     
       q=q+1;
       temp_num_positive3(q)=p;
       start_time_positive3 = same_data_time_positive3(o);
       p=0;
    end    
end
  
temp_num_positive3 =temp_num_positive3/2
firing_rate_mean_positive3 = mean(temp_num_positive3);
firing_rate_std_positive3 = std(temp_num_positive3);
figure(10)
errorbar(firing_rate_mean_positive3,firing_rate_std_positive3,'-or')
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212 saved data');
save('temp_num_positive3','temp_num_positive3');

%% multi month values
% add another month value eg: [mean1 mean2 mean3 ...]
all_month_mean_firing_rate = [firing_rate_mean_positive1 firing_rate_mean_positive2 firing_rate_mean_positive3];
all_month_std_firing_rate = [firing_rate_std_positive1 firing_rate_std_positive2 firing_rate_std_positive3];
% time, 3 means you have 3 months' data
Time = 1:1:3;  
figure(81)
errorbar(Time,all_month_mean_firing_rate,all_month_std_firing_rate,'-or')
%xlim([0 4]);
%xticks([0 1 2 3 4]);
xlabel('time (month)');
ylabel('firing rate');
title('Compare boxchart Data from Different months(spikes number per 100ms)');

