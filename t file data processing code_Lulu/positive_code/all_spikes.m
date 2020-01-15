%% spike plot 
% code by luluwang 
% 20180518
%% 
clc;
clear all;
close all;
%%S
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\0925cortexcluster1');
load('data_wave1.mat'); 
load('data_ts1.mat');
load('data_spikeTime_tfile1'); 

%% month 1
% all spikes  
data_wave1 = permute(data_wave(:,3,:),[1,3,2]);
% find mean
mean_data_wave1 = mean(data_wave1,2);
figure (1)
subplot(1,3,1);
plot(data_wave1); hold on; plot(mean_data_wave1,'k','LineWidth',2);  % change color of the mean 
title('all spikes 1');

% find out positive spikes 
[same_data_time_positive1,location_data_ts_positive1,location_data_spikeTime_tfile1] = intersect(data_ts, data_spikeTime_tfile);
data_wave_positive_spikes1 = data_wave1(:,location_data_ts_positive1);
% find out mean of the positive spikes 
mean_data_wave_positive_spikes1 = mean(data_wave_positive_spikes1,2);
figure (1)
subplot(1,3,2);
plot(data_wave_positive_spikes1); hold on; plot(mean_data_wave_positive_spikes1,'k','LineWidth',2);
title('positive spikes 1');

% find out negtive spikes
[same_data_time_negtive1, location_data_ts_negtive1] = setdiff(data_ts, data_spikeTime_tfile);
data_wave_negtive_spikes1 = data_wave1(:,location_data_ts_negtive1);
% find out mean of the negtive spikes 
mean_data_wave_negtive_spikes1 = mean(data_wave_negtive_spikes1,2);
figure (1)
subplot(1,3,3);
plot(data_wave_negtive_spikes1);hold on; plot(mean_data_wave_negtive_spikes1,'k','LineWidth',2);
title('negtive spikes 1');

% save data 
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\0925cortex');
save('data_wave1','data_wave1');    % all
save('data_wave_positive_spikes1','data_wave_positive_spikes1');  % positive
save('data_wave_negtive_spikes1','data_wave_negtive_spikes1');    % negtive
save('mean_data_wave1','mean_data_wave1');                        % mean

%%
% all spikes of month 2 
cd('D:\JIN YUN IXA ALL\all files_Luis');
load('data_wave2.mat'); 
load('data_ts2.mat');
load('data_spikeTime_tfile2'); 
data_wave2 = permute(data_wave(:,1,:),[1,3,2]);
mean_data_wave2 = mean(data_wave2,2);
figure (2)
subplot(1,3,1);
plot(data_wave2);hold on; plot(mean_data_wave2,'k','LineWidth',2);
title('all spikes 2');

% find out the positive spikes of month 2
[same_data_time_positive2,location_data_ts_positive2,location_data_spikeTime_tfile2] = intersect(data_ts, data_spikeTime_tfile);
data_wave_positive_spikes2 = data_wave2(:,location_data_ts_positive2);
mean_data_wave_positive_spikes2 = mean(data_wave_positive_spikes2,2);
figure (2)
subplot(1,3,2);
plot(data_wave_positive_spikes2);hold on; plot(mean_data_wave_positive_spikes2,'k','LineWidth',2);
title('positive spikes 2');

% find out the negtive spikes
[same_data_time_negtive2, location_data_ts_negtive2] = setdiff(data_ts, data_spikeTime_tfile);
data_wave_negtive_spikes2 = data_wave2(:,location_data_ts_negtive2);
mean_data_wave_negtive_spikes2 = mean(data_wave_negtive_spikes2,2);
figure (2)
subplot(1,3,3);
plot(data_wave_negtive_spikes2);hold on; plot(mean_data_wave_negtive_spikes2,'k','LineWidth',2);
title('negtive spikes 2');

% save all 
cd('D:\JIN YUN IXA ALL\all files_Luis\save');
save('data_wave2','data_wave2');
save('data_wave_positive_spikes2','data_wave_positive_spikes2');
save('data_wave_negtive_spikes2','data_wave_negtive_spikes2');
save('mean_data_wave2','mean_data_wave2');

%%
% all spikes of month 3
cd('D:\JIN YUN IXA ALL\all files_Luis');
load('data_wave3.mat'); 
load('data_ts3.mat');
load('data_spikeTime_tfile3'); 
data_wave3 = permute(data_wave(:,1,:),[1,3,2]);
mean_data_wave3 = mean(data_wave3,2);
figure (3)
subplot(1,3,1);
plot(data_wave3);hold on; plot(mean_data_wave2,'k','LineWidth',2);
title('all spikes 3');

% find out the positive spikes of month 3
[same_data_time_positive3,location_data_ts_positive3,location_data_spikeTime_tfile3] = intersect(data_ts, data_spikeTime_tfile);
data_wave_positive_spikes3 = data_wave3(:,location_data_ts_positive3);
mean_data_wave_positive_spikes3 = mean(data_wave_positive_spikes3,2);
figure (3)
subplot(1,3,2);
plot(data_wave_positive_spikes3);hold on; plot(mean_data_wave_positive_spikes3,'k','LineWidth',2);
title('positive spikes 3');

% find out the negtive spikes
[same_data_time_negtive3, location_data_ts_negtive3] = setdiff(data_ts, data_spikeTime_tfile);
data_wave_negtive_spikes3 = data_wave3(:,location_data_ts_negtive3);
mean_data_wave_negtive_spikes3 = mean(data_wave_negtive_spikes3,2);
figure (3)
subplot(1,3,3);
plot(data_wave_negtive_spikes3);hold on; plot(mean_data_wave_negtive_spikes3,'k','LineWidth',2);
title('negtive spikes');

% save all 
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212');
save('data_wave3','data_wave3');
save('data_wave_positive_spikes3','data_wave_positive_spikes3');
save('data_wave_negtive_spikes3','data_wave_negtive_spikes3');
save('mean_data_wave3','mean_data_wave3');