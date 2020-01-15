%% amplitude plot per time
% code by luluwang 
% 20180518
%% 
clc;
clear all;
close all;
%%
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212');
% all spikes of month 1 
load('data_wave1.mat'); 
load('data_ts1.mat');
load('data_spikeTime_tfile1'); 
data_wave1 = permute(data_wave(:,1,:),[1,3,2]);
% find out the positive spikes of month 1
[same_data_time_positive1,location_data_ts_positive1,location_data_spikeTime_tfile1] = intersect(data_ts, data_spikeTime_tfile);
data_wave_positive_spikes1 = data_wave1(:,location_data_ts_positive1);
% all spikes of month 2 
load('data_wave2.mat'); 
load('data_ts2.mat');
load('data_spikeTime_tfile2'); 
data_wave2 = permute(data_wave(:,1,:),[1,3,2]);
% find out the positive spikes of month 2
[same_data_time_positive2,location_data_ts_positive2,location_data_spikeTime_tfile2] = intersect(data_ts, data_spikeTime_tfile);
data_wave_positive_spikes2 = data_wave2(:,location_data_ts_positive2);
% all spikes of month 3 
load('data_wave3.mat'); 
load('data_ts3.mat');
load('data_spikeTime_tfile3'); 
data_wave3 = permute(data_wave(:,1,:),[1,3,2]);
% find out the positive spikes of month 3
[same_data_time_positive3,location_data_ts_positive3,location_data_spikeTime_tfile3] = intersect(data_ts, data_spikeTime_tfile);
data_wave_positive_spikes3 = data_wave3(:,location_data_ts_positive3);

%% (1) box chart
%  positive boxchart month 1 
[m1,n1]=size(data_wave_positive_spikes1);
temp_peaks_positive1=zeros(n1,1);
for i = 1:1:n1   
    %temp_data_ts = same_data_time_positive(i);   
temp_peaks_positive1(i)=max(abs(data_wave_positive_spikes1(:,i)));
end
temp_peaks_positive1=temp_peaks_positive1./65.536;

% save data 
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212 saved data');
save('temp_peaks_positive1','temp_peaks_positive1');    % all
% remove outliers
%max_temp_peaks_positive1 = max(temp_peaks_positive1);
%boxplot(temp_peaks_positive1, 'whisker',max_temp_peaks_positive1 );
figure (4)
subplot(1,3,1);
boxplot(temp_peaks_positive1);
% % h = boxplot(temp_peaks_positive1,'positions',0.25,'Colors','k','Notch','off','OutlierSize',7,'Symbol','k+');
% h = boxplot(temp_peaks_positive1);
% set(h(7,:),'Visible','off');


% xlabel('time');
% ylabel('amplitude');
% title('box chart 1');

%positive boxchart month 2 
[m2,n2]=size(data_wave_positive_spikes2);
temp_peaks_positive2=zeros(n2,1);
for i = 1:1:n2      
temp_peaks_positive2(i)=max(data_wave_positive_spikes2(:,i));
end
temp_peaks_positive2=temp_peaks_positive2./65.536;
figure (4)
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212 saved data');
save('temp_peaks_positive2','temp_peaks_positive2'); 
subplot(1,3,2);
boxplot(temp_peaks_positive2);
%set(h(7,:),'Visible','off');
% xlabel('time');
% ylabel('amplitude');
% title('box chart 2');

%positive boxchart month 3 
[m3,n3]=size(data_wave_positive_spikes3);
temp_peaks_positive3=zeros(n3,1);
for i = 1:1:n3    
temp_peaks_positive3(i)=max(data_wave_positive_spikes3(:,i));
end
temp_peaks_positive3=temp_peaks_positive3./32.768;
figure (4)
cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\1136_0212 saved data');
save('temp_peaks_positive3','temp_peaks_positive3'); 
subplot(1,3,3);
boxplot(temp_peaks_positive3);
%set(h(7,:),'Visible','off');
% xlabel('time');
% ylabel('amplitude');
% title('box chart 3');

% multi month values
figure(41)
%boxplot([temp_peaks_positive1,temp_peaks_positive2,...,temp_peaks_positiven],'Notch','on','Labels',{'month = 1','month = 2',...'month = 2'})
boxplot([temp_peaks_positive1,temp_peaks_positive2,temp_peaks_positive3],'labels',{'month = 1','month = 2','month = 3'});
%set(h(7,:),'Visible','off');
%xlabel('time');
ylabel('amplitude');
title('Amplitude plot per month');
