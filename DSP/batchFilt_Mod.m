% Batch filtering of signals
close all; clearvars; clc;
oldPath = "/idiap/temp/ssharma/compare19/data/ZFF_BSS/ZFFFiles_def_16preproc/";
list = dir(oldPath);
% newPath = "/idiap/temp/ssharma/compare19/data/ZFF_BSS/ZFFFiles_def_16preproc_ZZNetFilt/";
newPath = "/idiap/temp/ssharma/compare19/data/ZFF_BSS/";
%%
% -------------------------------------------------------------------------
% ZFFNet Pole1 (ZFFNet_ICSD2)
w1c=1340;
w1l=843.8;
w1h=1871;

w2c=3254;
rO_2 = 0.8;

w3c=6965;
w3l=6266;
w3h=7727;

% % ZFFNet Pole1 (ZFFNet_ICSD2)
% w1c=1396;
% w1l=896.5;
% w1h=1963;
% % r0 = 0.95;
% 
% w2c=5186;
% % w2l=4293;
% % w2h=5818;
% rO_2 = 0.8;
% 
% w3c=6936;
% w3l=6346;
% w3h=7636;
% % rO_3 = 0.6;



% 
% w1c=1340;
% w1l=843.8;
% w1h=1871;
% % 
% w2c=3254;
% rO_2 = 0.8;
% % 
% w3c=6965;
% r0_3 = 0.98;
% -------------------------------------------------------------------------
% % % % CryNet Pole1
% w1c=250;
% rO = 0.320;
% 
% w2c=3004;
% w2l=2020;
% w2h=3938;
% 
% w3c=6336;
% rO_3 = 0.62;


sampling_freq = 16000; % (in Hz) samplingfrequency

central_freq = w1c; % (in Hz) central frequency of resonator
central_freq_2 = w2c; % (in Hz) central frequency of resonator
central_freq_3 = w3c; % (in Hz) central frequency of resonator
rO = exp(-pi*(w1h-w1l)*1/sampling_freq); %Bandwidth of the resonator
% rO_2 = exp(-pi*(w2h-w2l)*1/sampling_freq); %Bandwidth of the resonator
% rO_3 = exp(-pi*(w3h-w3l)*1/sampling_freq); %Bandwidth of the resonator
rO_3 = exp(-pi*(w3h-w3l)*1/sampling_freq)+0.0850; %Bandwidth of the resonator


radian_freq = (central_freq/sampling_freq)*2*pi; % normalized central freq
radian_freq_2 = (central_freq_2/sampling_freq)*2*pi; % normalized central freq
radian_freq_3 = (central_freq_3/sampling_freq)*2*pi; % normalized central freq


dft_points = 2048; % resolution of the filter




% poly_Num = [1]; % numerator polynomial 
% poly_Den = [1 -2*rO_2*cos(radian_freq_2) rO_2.^2]; % denominator polynomial 
% [resonator_response, freq_axis] = freqz(poly_Num,poly_Den,dft_points); % generating filter response
% [anti_resonator_response, ~] = freqz(poly_Den,poly_Num,dft_points); % generating filter response



b0 = 1;
b1 = [1];
b2 = [1];
b3 = [1];
a1 = [1 -2*rO*cos(radian_freq) rO.^2];
a2 = [1 -2*rO_2*cos(radian_freq_2) rO_2.^2];
a3 = [1 -2*rO_3*cos(radian_freq_3) rO_3.^2];
b = b0*conv(conv(b1,b2), b3);
% b = b0*b2;
a = conv(conv(a1,a2), a3);
[res, fr] = freqz(b,a,dft_points);
figure;
plot(fr*sampling_freq/(2*pi), abs(res),'k','LineWidth',2);hold on; grid; 
%% Process
for i = 3:length(list)    
    filename=list(i,:).name;    
    [x,fs] = audioread(oldPath+filename);     
    x=(x-mean(x))/std(x);    
    y = filter(b,a,x);
%     y2 = filter(b2,a2,x);
%     y = y1+y2;
%     figure;
%     specgram(y, 512, 16000, hamming(400), []);
    audiowrite(newPath+filename,y,sampling_freq, 'BitsPerSample',24);
    clear x y filename
end




