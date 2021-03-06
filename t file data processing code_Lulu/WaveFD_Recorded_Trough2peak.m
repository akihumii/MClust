% function Wave_Function_Delay(infile,DelayInterval,numSpike,varargin)
%
% This function will plot waveform of spikes which are inside of defined range in one column
% and it will plot the other spikes in other column.
% Moreover, average pf waveform of spikes inside the time range and the other spikes will be
% plotted in another graph.
% An excelfile will be generated which contains number of spikes inside the range and total number of spikes.
% for each .t file, a .ntt file will be generated which contains only
% information about spikes which are inside of the time interval.
%
% Note 1: The mex-file Nlx2MatSpike.mexw32 or Nlx2MatSpike.mexw64 should be present
% Note 2: The mex-file Nlx2MatEV.mexw32 or Nlx2MatEV.mexw64 should be present
% Note 3: The mex-file Mat2NlxTT.mexw32 or Mat2NlxTT.mexw64 should be present
% in the current directory.
% Inputs:
%
% infile(mandatoy):
% Full path-name of text file containing the name of event-file(.Nev file)
% followed by list of .t files for which graphs should be constructed. This
% file should have the following format-
%
% C:\Users\salmanz\Dropbox\light\session 1 shutter on laser off\2014-10-23_10-12-12\Events.nev
% C:\Users\salmanz\Dropbox\light\session 1 shutter on laser off\2014-10-23_10-12-12\TT3_1.t
% C:\Users\salmanz\Dropbox\light\session 1 shutter on laser off\2014-10-23_10-12-12\TT3_2.t
% C:\Users\salmanz\Dropbox\light\session 1 shutter on laser off\2014-10-23_10-12-12\TT3_3.t
% C:\Users\salmanz\Dropbox\light\session 1 shutter on laser off\2014-10-23_10-12-12\TT3_4.t
% C:\Users\salmanz\Dropbox\light\session 1 shutter on laser off\2014-10-23_10-12-12\TT3_5.t
% C:\Users\salmanz\Dropbox\light\session 1 shutter on laser off\2014-10-23_10-12-12\TT3_6.t
% C:\Users\salmanz\Dropbox\light\session 1 shutter on laser off\2014-10-23_10-12-12\TT3_7.t
% C:\Users\salmanz\Dropbox\light\session 1 shutter on laser off\2014-10-23_10-12-12\TT3_8.t
%

% DelayInterval
% Delay interval is a matrix as a fuction of latency after light stimulus
% example: [0.003 0.01] which considers all spikes after 3 millisecond
% after light stimulus and before 10 millisecond.
%
% numSpike
% Number of spikes which we are interested in plotting. If it is more than the total
% number of spike, it is going to plot all of the spikes.
%
% Syntax:
% Wave_Function_Delay('infile.txt',[0.003 0.01],500)

% Edited by Sean on 16/11/2016 to include shutter delay and change of
% colour of graphs from blue, red, green, yellow to red, blue, green,
% yellow

%% comment by lulu
%%% cd('D:\JIN YUN IXA ALL')
%%% WaveFD_Recorded_Trough2peak('infile.txt',[0.003 0.01],500)
%%% stop the programme in Line 176
%%

function WaveFD_Recorded_Trough2peak(infile,DelayInterval,numSpike,varargin)
warning off;
% First check if the user has provided correct number of inputs. Otherwise
% throw an error.
narginchk(3,4);  % 3 is the minimum no. of inputs required, and 4 is the maximum
event_ttls=1;
outfile = {};
outputdir = {};
observation_start=DelayInterval(1);
observation_end=DelayInterval(2);

% Assign default values to outfile and outputdir if the user hasn't
% specified these.
if (nargin > 3)      %%% nargin = 3
    for i = 1:length(varargin)
        isxls =  regexp(varargin{i},'.*.xls');
        if( isempty(isxls))
            outputdir = varargin{i};
        else
            outfile = varargin{i};
        end
    end
end

if (isempty(outputdir))
    outputdir = 0;
end

if isempty(outfile)
    outfile = strcat(outputdir,'\','WFD_T2P_',num2str(DelayInterval(1)),'_',num2str(DelayInterval(2)),'_',date,'.xls');
end

outfp = fopen(outfile,'w+');
% First read the input file and get the event-file path and the .t files.
[fp, errmsg] = fopen(infile,'r');
if (fp == -1)
    error(['Could not open "', infile, '". ', errmsg]);
end

nev_file = strtrim(fgetl(fp));

tfiles = {};
i = 1;
while ~feof(fp)
    str = fgetl(fp);
    if ~strcmp(str,'')
        tfiles{i} = strtrim(str);
        nttfiles{i}=sprintf('%s%s%u%s',str(1:end-2),'.ntt');
        i = i+1;
    end
end

dpi = sprintf('%s%u','-r',600);

% Get a file-pointer to the output file to be written.
% outfp = fopen(outfile,'w+');
% For each t-file, extract the timestamps of spikes and construct PSTH and
% raster plots by aligning these to event occurrences. Do this for every
% event TTL specified by user.

for i = 1:length(tfiles)
    
    if ~exist(nttfiles{i},'file')
        error('Couldn''t find the TTList listed in the input file. Make sure the name and path is correct.')
    else
        [ts,ScNumbers,CellNumbers,Features,wave,head]=readNlxSpikeFile(nttfiles{i});
        tsOriginal = ts;
        ts=round(ts(:)*0.01);
    end
    
    %% lulu add save data ntt
    cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\0305_negative');
    data_wave = (wave);
    fname = strcat('data_wave','.mat');
    save(fname,'data_wave');
    
    data_ts = (ts);
    fname = strcat('data_ts','.mat');
    save(fname,'data_ts');
    
    %%
    f = head(16);
    s = head(17);
    a =  head(11);
    SamFreq = textscan(f{1},'%*s %n');
    SamplingFrequency = SamFreq{1}(1);
    number = textscan(s{1},'%*s %n');
    number1 = textscan(a{1},'%*s %n %n %n %n');
    F = number{1}(1);
    % Event timestamps recorded in .nev file are extracted using the
    % following function call
    [spike_timestamps spikeTime] = readtfile(tfiles{i});
    
    %% lulu add save data t file
    cd('F:\NTU Research\matlab\t file data processing code_Lulu\save\0305_negative');
%     data_spike_timestamps_tfile = (spike_timestamps);
%     fname = strcat('data_spike_timestamps_tfile','.mat');
%     save(fname,'data_spike_timestamps_tfile');
    
    data_spikeTime_tfile = (spikeTime);
    fname = strcat('data_spikeTime_tfile','.mat');
    save(fname,'data_spikeTime_tfile');
    
    %%% stop the programme here
    
    %%
    
    % Get the name of the t-file from the full path-name.
    % e.g. if tfilename = 'N:\Anjali\Data\Rat2\beg1\Sc1_1.t',
    % clusindex = Sc1_1
    % % %      [match] = regexp(tfiles{i},'.*\\(TT.*\.t)','tokens');
    % % %    %  clusindex =  regexprep(match{1},'\.t','');
    % % %      clusindex = Clu_20
    % % %
    % % %     % If an output-directory is not specified, then store images in the
    % % %     % current t-file's directory.
    % % %     if (~outputdir)
    % % %         outputdir = regexprep(tfiles{i},'\\TT.*\.t','\');
    % % %     end
    % % %     fprintf(1,'Output-directory for %s.t:\t%s\n',char(clusindex),outputdir);
    
    shtter_off_events=extract_event_ts(nev_file, 0);
    
    for j = 1:length(event_ttls)
        event_ts = [];
        % Extract timestamps (in sec) for the current event from the .Nev file
        event_ts = extract_event_ts(nev_file, event_ttls(j));
        
        % Plot the PSTH and raster plot and get the figure handle and
        % firing-rate array
        ModePlot =2;
        [plothandle, numIn, idAll,waveInRange,Timestamps,ScNum_new,CellNum_new,Features_new,Trough2PeakR,Peak2Peak,M,MD,MDD] = plotdata(spike_timestamps, event_ts,observation_start,observation_end,tfiles{i},ts,wave,spikeTime,numSpike,F,number1,ModePlot,tsOriginal,ScNumbers,CellNumbers,Features,SamplingFrequency);
        if isempty(plothandle)
            
        else
            number1 = textscan(a{1},'%*s %n %n %n %n');
            m = {}; %Luis: Declare counting variable for following "For" loop
            plotname2 = strcat(outputdir,'\WFD_T2P_',num2str(event_ttls(j)),num2str(DelayInterval(1)),'_',num2str(DelayInterval(2)),'_',clusindex,'.png');%Modified by Luis so that name is easier to keep together with the other files
            plotname2 = char(plotname2);
            %set(plothandle{1},'PaperUnits','inches','PaperPosition',[0 0 3 8])
            print(plothandle{1}, dpi,'-dpng', plotname2);
            close;
            fprintf(outfp, '%s\n',tfiles{i});
            fprintf(outfp, '%s\n','Number of spikes ');
            fprintf(outfp,'%d\t',length(spike_timestamps));
            fprintf(outfp,'%s\n','');
            fprintf(outfp, '%s\n','Spike width (ms)');
            fprintf(outfp,'%3.4f\t',Trough2PeakR);
            fprintf(outfp,'%s\n','');
            fprintf(outfp, '%s\n','Peak-to-Peak Ratio');
            fprintf(outfp,'%3.4f\t',Peak2Peak);
            fprintf(outfp,'%s\n','');
            fprintf(outfp, '%s\n','Number of spikes inside the range');
            fprintf(outfp,'%d\t',numIn);
            fprintf(outfp,'%s\n','');
            fprintf(outfp, '%s\n','timestamps of spikes which are inside the range');
            fprintf(outfp,'%d\t',spike_timestamps(idAll));
            fprintf(outfp,'%s\n','');%Added by Luis
            fprintf(outfp, '%s\n','ID of spikes which are inside the range');%Added by Luis
            fprintf(outfp,'%d\t',idAll);%Added by Luis
            fprintf(outfp,'%s\n','');
            fprintf(outfp, '%s\n','Average waveform (32 points)');
            for m = 1: 4 %Luis: For loop to account output of values of each channel
                fprintf(outfp,'%4.4f\t',M(:,m)); %Luis
                fprintf(outfp,'%s\n','');
            end %Luis
            fprintf(outfp, '%s\n','Average waveform 1st Derivative (31 points)');
            %fprintf(outfp,'%4.4f\t%4.4f\t%4.4f\t%4.4f\n',MD.');
            for m = 1: 4 %Luis: For loop to account output of values of each channel
                fprintf(outfp,'%4.4f\t',MD(:,m)); %Luis
                fprintf(outfp,'%s\n','');
            end %Luis
            fprintf(outfp, '%s\n','Average waveform 2nd Derivative (30 points)');
            %fprintf(outfp,'%4.4f\t%4.4f\t%4.4f\t%4.4f\n',MDD.');
            for m = 1: 4 %Luis: For loop to account output of values of each channel
                fprintf(outfp,'%4.4f\t',MDD(:,m)); %Luis
                fprintf(outfp,'%s\n','');
            end %Luis
            fprintf(outfp,'%s\n','');
            fprintf(outfp,'%s\n','');
            fprintf(outfp, '\n\n');
            
            
            AppendToFileFlag = 0;
            ExportMode = 1;
            NumRecs = length( Timestamps);
            ModeArray = 1;
            nameNTT = strcat(clusindex{1}(1:end-2),'_',clusindex{1}(end),'_',num2str(DelayInterval(1)),'_',num2str(DelayInterval(2)),'.ntt')
            
            Mat2NlxTT(nameNTT, AppendToFileFlag, ExportMode, ModeArray, NumRecs, [1 1 1 1 1 1],  Timestamps,CellNum_new,Features_new,waveInRange, head); % Corrected by Luis, originally code used Mat2NlxSpike, but it didn't work, so I changed it to Mat2NlxTT, which it does work to generate new .ntt files
            
        end
    end
    
end

fprintf(1,'Output file location:\t%s\n',outfile);
fclose(outfp);
%%

function [plothandle, numIn, idAll,waveInRange,Timestamps,ScNum_new,CellNum_new,Features_new,Trough2PeakR,Peak2Peak,M,MD,MDD] = plotdata(spike_timestamps, event_ts,observation_start,observation_end, tfilename,ts,wave,spikeTime,numSpike,F,number1,ModePlot,tsOriginal,ScNumbers,CellNum,Features,SamplingFrequency)


N=length(event_ts);
k=1;
kk = 1 ;
idAll = [];
wave1=[];wave2=[];wave3=[];wave4=[];
wave11=[];wave22=[];wave33=[];wave44=[];
r = {};
Timestamps = zeros(size(idAll));
waveInRange = zeros(32,4,length(idAll));
ScNum_new = zeros(size(idAll));
Features_new = zeros(8,length(idAll));
CellNum_new = zeros(size(idAll));
for i = 1: N
    % Align the spike sequence with the current event
    
    time_diffs = spike_timestamps - event_ts(i)  - 0.002778442212323;
    % Spikes which lie in the user-specified time-range around each event's
    % occurrence will be plotted.
    id=find(time_diffs >= observation_start & time_diffs < observation_end);
    idAll = [idAll; id];
    time_diffs1 = time_diffs(find(time_diffs >= observation_start & time_diffs < observation_end));
    
    numIn = length(idAll)   ;
    
    for j = 1:length(time_diffs1)
        
        Timestamps(k) = tsOriginal(find(ts==spikeTime(id(j))));
        ScNum_new(k) = ScNumbers(find(ts==spikeTime(id(j))));
        Features_new(:,k)=  Features(:,ts==spikeTime(id(j)));
        CellNum_new(k) =  CellNum(find(ts==spikeTime(id(j))));
        r{k}=wave(:,:,ts==spikeTime(id(j)));
        waveInRange(:,:,k) = r{k};
        wave1(:,k)=r{:,k}(:,1)*F*10^6;% Luis: These variables keep track of all values present on the 32 points of each waveform within the user-specified range.
        wave2(:,k)=r{:,k}(:,2)*F*10^6;
        wave3(:,k)=r{:,k}(:,3)*F*10^6;
        wave4(:,k)=r{:,k}(:,4)*F*10^6;
        
        k=k+1;
        
    end
    
end
count = 1:1:length(spike_timestamps);
if numSpike>length(spike_timestamps)
    numSpike =length(spike_timestamps);
end
r1 = {};
for jj = 1:length(spike_timestamps)
    aa = find(count(jj) ==idAll);
    if isempty(aa) && count(jj)<=numSpike
        r1{kk}= wave(:,:,ts==spikeTime(jj));
        wave11(:,kk)=r1{:,kk}(:,1)*F*10^6;% Luis: These variables keep track of all values present on the 32 points of each waveform outside of the user-specified range.
        wave22(:,kk)=r1{:,kk}(:,2)*F*10^6;
        wave33(:,kk)=r1{:,kk}(:,3)*F*10^6;
        wave44(:,kk)=r1{:,kk}(:,4)*F*10^6;
        kk=kk+1;
    end
end

a1 = [];a2=[];a3=[];a4=[];
a11=[];a22=[];a33=[];a44=[];
a5=[];a6=[];a7=[];a8=[];
a55=[];a66=[];a77=[];a88=[];

Ia1=[];Ia2=[];Ia3=[];Ia4=[];
Ia5=[];Ia6=[];Ia7=[];Ia8=[];
D11 = [];ID11 = [];D22 = [];ID22 = []; D33= [];ID33 = []; D44 = []; ID44= [];
D55 = [];ID55 = [];D66 = [];ID66 = []; D77= [];ID77 = []; D88 = []; ID88= [];

m1 = [];m2=[];m3=[];m4=[];
m1D = [];m2D=[];m3D=[];m4D=[];
m1DD = [];m2DD=[];m3DD=[];m4DD=[];


Trough2PeakR=[];
Peak2Peak=[];

W1D1 = diff(wave1);W1D2 = diff(wave2);W1D3 = diff(wave3);W1D4 = diff(wave4);% Compute 1st derivative of waveforms
W2D1 = diff(wave1,2);W2D2 = diff(wave2,2);W2D3 = diff(wave3,2);W2D4 = diff(wave4,2); % Compute 2nd derivative of waveforms

if ~isempty(r)
    [a1,Ia1]= max(max(wave1,[],2)); % Maximum value of spikes within user-defined range Channel 01-04, Ia1-Ia4 variable finds the index of the largest value.
    [a2,Ia2]= max(max(wave2,[],2));
    [a3,Ia3]= max(max(wave3,[],2));
    [a4,Ia4]= max(max(wave4,[],2));
end
if ~isempty(r1)
    a11= max(max(wave11)); % Maximum value of spikes outside user-defined range Channel 01-04
    a22= max(max(wave22));
    a33= max(max(wave33));
    a44= max(max(wave44));
end
Max_all=max([a1 a2 a3 a4 a11 a22 a33 a44]); %Establish value for maximum value displayed on Y-axis for all channels

if ~isempty(r)
    [a5,Ia5]= min(min(wave1,[],2)); % Minimum value of spikes within user-defined range Channel 01-04
    [a6,Ia6]= min(min(wave2,[],2));
    [a7,Ia7]= min(min(wave3,[],2));
    [a8,Ia8]= min(min(wave4,[],2));
end
if ~isempty(r1)
    a55= min(min(wave11)); % Minimum value of spikes outside user-defined range Channel 01-04
    a66= min(min(wave22));
    a77= min(min(wave33));
    a88= min(min(wave44));
end
Min_all=min([a5 a6 a7 a8 a55 a66 a77 a88]); %Establish value for minimum value displayed on Y-axis for all channels

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Scale for 1st derivative
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(r1)
    [D11, ID11]= max(max(W1D1,[],2)); % Maximum value of spikes outside user-defined range Channel 01,02,03,04
    [D22, ID22]= max(max(W1D2,[],2));
    [D33, ID33]= max(max(W1D3,[],2));
    [D44, ID44]= max(max(W1D4,[],2));
end
Max_allD=max([D11 D22 D33 D44]); %Establish value for maximum value displayed on Y-axis for all channels

if ~isempty(r1)
    [D55,ID55]= min(min(W1D1,[],2)); % Minimum value of spikes outside user-defined range Channel 01,02,03,04
    [D66,ID66]= min(min(W1D2,[],2));
    [D77,ID77]= min(min(W1D3,[],2));
    [D88,ID88]= min(min(W1D4,[],2));
end
Min_allD=min([D55 D66 D77 D88]); %Establish value for minimum value displayed on Y-axis for all channels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Scale for 2nd derivative
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(r1)
    [DD11, IDD11]= max(max(W2D1,[],2)); % Maximum value of spikes outside user-defined range Channel 01,02,03,04
    [DD22, IDD22]= max(max(W2D2,[],2));
    [DD33, IDD33]= max(max(W2D3,[],2));
    [DD44, IDD44]= max(max(W2D4,[],2));
end
Max_allDD=max([DD11 DD22 DD33 DD44]); %Establish value for maximum value displayed on Y-axis for all channels

if ~isempty(r1)
    [DD55,IDD55]= min(min(W2D1,[],2)); % Minimum value of spikes outside user-defined range Channel 01,02,03,04
    [DD66,IDD66]= min(min(W2D2,[],2));
    [DD77,IDD77]= min(min(W2D3,[],2));
    [DD88,IDD88]= min(min(W2D4,[],2));
end
Min_allDD =min([DD55 DD66 DD77 DD88]); %Establish value for minimum value displayed on Y-axis for all channels

if isempty(W1D1) %Set of "If" statements are included to account in case a tetrode doesn't have any spikes in the specified time window.
    W1D1 = zeros(1,31);W2D1 = zeros(1,30);Max_allD = Max_all;Min_allD = Min_all;Max_allDD = Max_all;Min_allDD = Min_all;m1=zeros(1,32);m1D=zeros(1,31);m1DD=zeros(1,30);
end
if isempty(W1D2)
    W1D2 = zeros(1,31);W2D2 = zeros(1,30);Max_allD = Max_all;Min_allD = Min_all;Max_allDD = Max_all;Min_allDD = Min_all;m2=zeros(1,32);m2D=zeros(1,31);m2DD=zeros(1,30);
end
if isempty(W1D3)
    W1D3 = zeros(1,31);W2D3 = zeros(1,30);Max_allD = Max_all;Min_allD = Min_all;Max_allDD = Max_all;Min_allDD = Min_all;m3=zeros(1,32);m3D=zeros(1,31);m3DD=zeros(1,30);
end
if isempty(W1D4)
    W1D4 = zeros(1,31);W2D4 = zeros(1,30);Max_allD = Max_all;Min_allD = Min_all;Max_allDD = Max_all;Min_allDD = Min_all;m4=zeros(1,32);m4D=zeros(1,31);m4DD=zeros(1,30);
end


P2Ta = [a1 Ia1 a5 Ia5;a2 Ia2 a6 Ia6;a3 Ia3 a7 Ia7;a4 Ia4 a8 Ia8];%Luis: This matrix finds arranges the maximum/minimum and pairs it with the index of each.
[P2Tb,A] = max([a1 a2 a3 a4]); %Max function find which is the channel with the largest amplitude.

if isempty(P2Ta); % Luis: This if statement is for cases were there are no spikes in the user-specified range.
    P = 0;T = 0;
    Peak2Peak = 0;
else
    P=P2Ta(A,2); T=P2Ta(A,4); %Luis: Find the index # for the peak and trough in the channel with the maximum amplitude.
    Trough2PeakR = abs((P*0.03125)-(T*0.03125)); %Luis: Multiply by 31.25 us each index and find latency.
    Peak2Peak = (abs(P2Ta([A 1]))/abs(P2Ta([A 3]))); %Luis: Find Peak to trough amplitude ratio.
end

x1 = [0:1:31]/SamplingFrequency*1000;
x1D = [0:1:30]/SamplingFrequency*1000;
x2D = [0:1:29]/SamplingFrequency*1000;

if ModePlot ==2
    name = strcat(tfilename,'(Derivative)');
    suptitle(name);
    subplot(4,4,1)
    hold on
    if ~isempty(r)
        k1= size(wave1,2);
        for i=1:length(r) %Luis
            plot (x1,wave1(:,i), 'LineWidth',1, 'Color', 'red') %Luis
            hold on %Luis
        end %Luis
        plot (x1, mean(wave1,2), 'LineWidth',2,'Color', 'blue')
        m1 = mean(wave1,2); %Luis: Added new variable to display all 32 points of the original waveform for all channels
    end
    title(['Ch',(num2str(number1{1}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_all Max_all]);
    set(gca, 'XLim',[0 31]/SamplingFrequency*1000);
    grid on
    
    subplot(4,4,2)
    hold on
    if ~isempty(r1)
        k1= size(wave11,2);
        for jj = 1: k1 %Luis
            plot (x1, wave11(:,jj), 'LineWidth',0.25, 'LineStyle','-.','Color', 'black'); %Luis
            hold on %Luis
        end%Luis
        plot (x1, mean(wave11,2), 'LineWidth',2,'Color', 'b')
    end
    title(['Ch',(num2str(number1{1}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_all Max_all]);
    set(gca, 'XLim',[0 31]/SamplingFrequency*1000);
    grid on
    
    subplot(4,4,3)
    hold on
    if ~isempty(r1)
        k1= size(W1D1,2);
        for jj = 1: k1 %Luis
            plot (x1D, W1D1(:,jj), 'LineWidth',0.25, 'LineStyle','-.','Color', 'black'); %Luis
            hold on %Luis
        end%Luis
        plot (x1D, mean(W1D1,2), 'LineWidth',2,'Color', 'b')
        m1D = mean(W1D1,2); %Luis: Added new variable to display all 31 points of the 1st derivative of the original waveform for all channels
    end
    title(['Ch',(num2str(number1{1}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_allD Max_allD]);
    set(gca, 'XLim',[0 30]/SamplingFrequency*1000);
    grid on
    
    subplot(4,4,4)
    hold on
    if ~isempty(r1)
        k1= size(W2D1,2);
        for jj = 1: k1 %Luis
            plot (x2D, W2D1(:,jj), 'LineWidth',0.25, 'LineStyle','-.','Color', 'black');%Luis
            hold on %Luis
        end %Luis
        plot (x2D, mean(W2D1,2), 'LineWidth',2,'Color', 'red')
        m1DD = mean(W2D1,2);
    end
    title(['Ch',(num2str(number1{1}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_allD Max_allD]);
    set(gca, 'XLim',[0 29]/SamplingFrequency*1000);
    grid on
    
    subplot(4,4,5)
    hold on
    if ~isempty(r)
        for i=1:length(r) %Luis
            plot (x1,wave2(:,i), 'LineWidth',1,'Color', 'blue') %Luis
            hold on %Luis
        end %Luis
        plot (x1, mean(wave2,2), 'LineWidth',2,'Color', 'red')
        m2 = mean(wave2,2); %Luis: Added new variable to display all 32 points of the original waveform for all channels
    end
    title(['Ch',(num2str(number1{2}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_all Max_all]);
    set(gca, 'XLim',[0 31]/SamplingFrequency*1000);
    grid on
    
    subplot(4,4,6)
    hold on
    if ~isempty(r1)
        k1= size(wave22,2);
        for jj = 1: k1 %Luis
            plot (x1, wave22(:,jj), 'LineWidth',0.25, 'LineStyle','-.','Color', 'black');%Luis
            hold on %Luis
        end %Luis
        plot (x1, mean(wave22,2), 'LineWidth',2,'Color', 'red')
    end
    title(['Ch',(num2str(number1{2}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_all Max_all]);
    set(gca, 'XLim',[0 31]/SamplingFrequency*1000);
    grid on
    
    subplot(4,4,7)
    hold on
    if ~isempty(r1)
        k1= size(W1D2,2);
        for jj = 1: k1 %Luis
            plot (x1D, W1D2(:,jj), 'LineWidth',0.25, 'LineStyle','-.','Color', 'black'); %Luis
            hold on %Luis
        end%Luis
        plot (x1D, mean(W1D2,2), 'LineWidth',2,'Color', 'b')
        m2D = mean(W1D2,2); %Luis: Added new variable to display all 31 points of the 1st derivative of the original waveform for all channels
    end
    title(['Ch',(num2str(number1{2}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_allD Max_allD]);
    set(gca, 'XLim',[0 30]/SamplingFrequency*1000);
    grid on
    
    subplot(4,4,8)
    hold on
    if ~isempty(r1)
        k1= size(W2D2,2);
        for jj = 1: k1 %Luis
            plot (x2D, W2D2(:,jj), 'LineWidth',0.25, 'LineStyle','-.','Color', 'black');%Luis
            hold on %Luis
        end %Luis
        plot (x2D, mean(W2D2,2), 'LineWidth',2,'Color', 'red')
        m2DD = mean(W2D2,2);
    end
    title(['Ch',(num2str(number1{2}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_allD Max_allD]);
    set(gca, 'XLim',[0 29]/SamplingFrequency*1000);
    grid on
    
    subplot(4,4,9)
    hold on
    if ~isempty(r)
        for i=1:length(r) %Luis
            plot (x1,wave3(:,i), 'LineWidth',1,'Color', 'yellow')%Luis
        end %Luis
        plot (x1, mean(wave3,2), 'LineWidth',2,'Color', 'green')
        m3 = mean(wave3,2); %Luis: Added new variable to display all 32 points of the original waveform for all channels
    end
    title(['Ch',(num2str(number1{3}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_all Max_all]);
    set(gca, 'XLim',[0 31]/SamplingFrequency*1000);
    grid on
    
    subplot(4,4,10)
    hold on
    if ~isempty(r1)
        k1= size(wave33,2);
        for jj = 1: k1 %Luis
            plot (x1, wave33(:,jj), 'LineWidth',0.25, 'LineStyle','-.','Color', 'black');%Luis
            hold on %Luis
        end %Luis
        plot (x1, mean(wave33,2), 'LineWidth',2,'Color', 'green')
    end
    title(['Ch',(num2str(number1{3}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_all Max_all]);
    set(gca, 'XLim',[0 31]/SamplingFrequency*1000);
    grid on
    
    subplot(4,4,11)
    hold on
    if ~isempty(r1)
        k1= size(W1D3,2);
        for jj = 1: k1 %Luis
            plot (x1D, W1D3(:,jj), 'LineWidth',0.25, 'LineStyle','-.','Color', 'black'); %Luis
            hold on %Luis
        end%Luis
        plot (x1D, mean(W1D3,2), 'LineWidth',2,'Color', 'b')
        m3D = mean(W1D3,2); %Luis: Added new variable to display all 31 points of the 1st derivative of the original waveform for all channels
    end
    title(['Ch',(num2str(number1{3}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_allD Max_allD]);
    set(gca, 'XLim',[0 30]/SamplingFrequency*1000);
    grid on
    
    subplot(4,4,12)
    hold on
    if ~isempty(r1)
        k1= size(W2D3,2);
        for jj = 1: k1 %Luis
            plot (x2D, W2D3(:,jj), 'LineWidth',0.25, 'LineStyle','-.','Color', 'black');%Luis
            hold on %Luis
        end %Luis
        plot (x2D, mean(W2D3,2), 'LineWidth',2,'Color', 'red')
        m3DD = mean(W2D3,2);
    end
    title(['Ch',(num2str(number1{3}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_allD Max_allD]);
    set(gca, 'XLim',[0 29]/SamplingFrequency*1000);
    grid on
    
    subplot(4,4,13)
    hold on
    if ~isempty(r)
        for i=1:length(r) %Luis
            plot (x1,wave4(:,i), 'LineWidth',1,'Color', 'green') %Luis
        end %Luis
        plot (x1, mean(wave4,2), 'LineWidth',2,'Color', 'yellow')
        m4 = mean(wave4,2); %Luis: Added new variable to display all 32 points of the original waveform for all channels
    end
    title(['Ch',(num2str(number1{4}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_all Max_all]);
    set(gca, 'XLim',[0 31]/SamplingFrequency*1000);
    grid on
    
    subplot(4,4,14)
    hold on
    if ~isempty(r1)
        k1= size(wave44,2);
        for jj = 1: k1 %Luis
            plot (x1, wave44(:,jj), 'LineWidth',0.25, 'LineStyle','-.','Color', 'black'); %Luis
            hold on %Luis
        end %Luis
        plot (x1, mean(wave44,2), 'LineWidth',2,'Color', 'yellow')
    end
    title(['Ch',(num2str(number1{4}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_all Max_all]);
    set(gca, 'XLim',[0 31]/SamplingFrequency*1000);
    grid on
    hold off
    
    subplot(4,4,15)
    hold on
    if ~isempty(r1)
        k1= size(W1D4,2);
        for jj = 1: k1 %Luis
            plot (x1D, W1D4(:,jj), 'LineWidth',0.25, 'LineStyle','-.','Color', 'black'); %Luis
            hold on %Luis
        end%Luis
        plot (x1D, mean(W1D4,2), 'LineWidth',2,'Color', 'b')
        m4D = mean(W1D4,2); %Luis: Added new variable to display all 31 points of the 1st derivative of the original waveform for all channels
    end
    title(['Ch',(num2str(number1{4}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_allD Max_allD]);
    set(gca, 'XLim',[0 30]/SamplingFrequency*1000);
    grid on
    
    subplot(4,4,16)
    hold on
    if ~isempty(r1)
        k1= size(W2D4,2);
        for jj = 1: k1 %Luis
            plot (x2D, W2D4(:,jj), 'LineWidth',0.25, 'LineStyle','-.','Color', 'black');%Luis
            hold on %Luis
        end %Luis
        plot (x2D, mean(W2D4,2), 'LineWidth',2,'Color', 'red')
        m4DD = mean(W2D4,2);
    end
    title(['Ch',(num2str(number1{4}))+1]);
    ylabel({'uV'},'FontSize',8);
    xlabel({'ms'},'FontSize',8);
    set(gca, 'YLim',[Min_allD Max_allD]);
    set(gca, 'XLim',[0 29]/SamplingFrequency*1000);
    grid on
    
    set(gcf, 'PaperUnits', 'inches');
    
    M = [m1 m2 m3 m4]; %Luis: "M" is a matrix which cotains all 32 points recorded for each spike
    MD = [m1D m2D m3D m4D]; %Luis: "MD" is a matrix which cotains 31 points corresponding to the 1st Derivative calculated from the 32 points of each spike
    MDD = [m1DD m2DD m3DD m4DD]; %Luis: "MDD" is a matrix which cotains 30 points corresponding to the 2nd Derivative calculated from the 32 points of each spike
    
    x_width=15.25 ;
    y_width=9.125;
    set(gcf, 'PaperPosition', [0 0 x_width y_width]);
    plothandle = { gcf };
end

fig = gcf;
fig.Position = [230 250 400 800];


%%


% This function will extract timestamps of a user-specified event from the
% .Nev file generated during recording.

function event_ts = extract_event_ts(nev_file, event_ttl)
% Table of Event-data
%         EventString                       TTL
%        -----------------------------------------
%         Reward collection            128 (0x0080)
%         Stimulus displayed            64 (0x0040)
%         Correct touch                 32 (0x0020)
%         Incorrect touch               16 (0x0010)
%         Start of ITI after timeout    08 (0x0008)
%         End of ITI                    04 (0x0004)

fprintf(1,'%s\t%s\n\n',strcat('Reading timestamps for TTL = ',num2str(event_ttl),' from '),nev_file);
[Timestamps, TTLs] = ...
    Nlx2MatEV(nev_file, [1 0 1 0 0], 0, 1, [] );

event_ts = Timestamps(find(TTLs == event_ttl));
event_ts = event_ts/1000000; % convert to sec
%%


% Function to extract timestamps of all spikes fired by a cell in one
% session. Timestamp values are in seconds.
function [spike_timestamps spikeTime] = readtfile(tfilename)

% Check if file exist
tfp = fopen(tfilename, 'rb','b');
if (tfp == -1)
    warning(['Could not open tfile ' tfilename]);
    spikeTime = -1;
    return;
end
ReadHeader(tfp);
fprintf(1,'%s\t%s\n\n',strcat('Reading timestamps from t-file: '),tfilename);
spikeTime = fread(tfp,inf,'uint32');	%read as 32 bit ints
spike_timestamps = spikeTime/ 10000;    %convert unit to second
% spike_timestamps(1:10)'
% spike_timestamps(end-10:end)'
fclose (tfp);



% This function reads the header of the t-file
%%
function H = ReadHeader(fp)
% H = ReadHeader(fp)
%  Reads NSMA header, leaves file-read-location at end of header
%  INPUT:

%      fid -- file-pointer (i.e. not filename)
%  OUTPUT:
%      H -- cell array.  Each entry is one line from the NSMA header
% Now works for files with no header.
% ADR 1997
% version L4.1
% status: PROMOTED
% v4.1 17 nov 98 now works for files sans header
%---------------

% Get keys
beginheader = '%%BEGINHEADER';
endheader = '%%ENDHEADER';

iH = 1; H = {};
curfpos = ftell(fp);

% look for beginheader
headerLine = fgetl(fp);
if strcmp(headerLine, beginheader)
    H{1} = headerLine;
    while ~feof(fp) && ~strcmp(headerLine, endheader)
        headerLine = fgetl(fp);
        iH = iH+1;
        H{iH} = headerLine;
    end
else % no header
    fseek(fp, curfpos, 'bof');
end





function [ts,Sc_Numbers,Cell_Numbers,Params,wave,head] = readNlxSpikeFile(spikeFile)



fieldSelection = [1,1,1,1,1];
extractHeader = 1;
extractMode = 1;

% Read the ntt file
[ts,Sc_Numbers,Cell_Numbers,Params,wave,head] = Nlx2MatSpike(spikeFile,fieldSelection,extractHeader,extractMode);
%%



