% Batch filtering of signals
close all; clearvars; clc;
oldPath = "/idiap/home/ssharma/Shivam/Workstation/Work/Datasetup/wav2/noSil/preProc2/Anxt/";
list = dir(oldPath);
% newPath = "/idiap/home/ssharma/Shivam/Workstation/Work/Datasetup/ZFFOutput2/noSil/FilSig_Cry_CryNet_1Pole/1_pp2_SFF_3004H_sameBW/Pain/";
newPath = "/idiap/home/ssharma/Shivam/Workstation/Work/Datasetup/wav2/noSil/FilSig_Cry_ZFFNet_1Pole/1_pp2_SFF_1340H_sameBW/Anxt/";
% ZFFNet Pole1
w1c=1340;
w1l=843.8;
w1h=1871;

% CryNet Pole1
% w1c=3004;
% w1l=2020;
% w1h=3938;

sampling_freq = 16000; % (in Hz) samplingfrequency
central_freq = w1c; % (in Hz) central frequency of resonator
rO = exp(-pi*(w1h-w1l)*1/sampling_freq); %Bandwidth of the resonator
dft_points = 2048; % resolution of the filter

radian_freq = (central_freq/sampling_freq)*2*pi; % normalized central freq
poly_Num = [1]; % numerator polynomial 
poly_Den = [1 -2*rO*cos(radian_freq) rO.^2]; % denominator polynomial 
[resonator_response, freq_axis] = freqz(poly_Num,poly_Den,dft_points); % generating filter response
figure;plot(freq_axis*sampling_freq/(2*pi), abs(resonator_response),':m','LineWidth',2);hold on; grid; 
%% Process
for i = 3:length(list)    
    filename=list(i,:).name;    
    [x,fs] = audioread(oldPath+filename);   
    x=(x-mean(x))/std(x);
%     xd = [x(1); diff(x)];
    y = filter(poly_Num,poly_Den,x);
%     figure;
%     specgram(y, 512, 16000, hamming(400), []);
    audiowrite(newPath+filename,y,sampling_freq);
    clear x y filename
end




