close all; clearvars; clc;
oldPath = "/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/compare19/data/ZFF_BSS/ZFFFiles_def_16preproc/";
list = dir(oldPath);
newPath = "/idiap/temp/ssharma/Datasetup/ZFF_BSS_IIR_1PoleZFFNet30kwFilt/";

% close all; clearvars; clc;
w1c=770.3;
% r0 = 0.98;
w1h=1150;
w1l=422.3;
sampling_freq = 16000; % (in Hz) samplingfrequency
r0 = exp(-pi*(w1h-w1l)*1/sampling_freq); %Bandwidth of the resonator


central_freq = w1c; % (in Hz) central frequency of resonator
radian_freq = (central_freq/sampling_freq)*2*pi; % normalized central freq
dft_points = 2048; % resolution of the filter
poly_Num = [1]; % numerator polynomial 
poly_Den = [1 -2*r0*cos(radian_freq) r0.^2]; % denominator polynomial 
[res, fr] = freqz(poly_Num,poly_Den,dft_points); % generating filter response
figure;
f1 = plot(fr*sampling_freq/(2*pi), abs(res),'--r','LineWidth',2);hold on; grid; 
f1 = plot(freq,20*log10(filters), '--r', 'LineWidth',2);grid;
xlabel('freq (Hz)'); ylabel('|X[\omega]|'); 
% title('CumFreqRes, Cry, 30 \itkw')
title('CFR, CryNet (2L, 30kw) and 3 Pole ZFFNet (2L, 16kw) approximation')
legend('CryNet (2L, 30kw)', 'Reso\_3Pole (2L, 16kw)')
saveas(f1,'9_2Layers_CryNet30kw_3PoleResoZFFNet16kw_subseg2stats2_CFRF.jpg')
%% Process
for i = 3:length(list)    
    filename=list(i,:).name;    
    [x,fs] = audioread(oldPath+filename);     
    x=(x-mean(x))/std(x);    
    y = filter(poly_Num,poly_Den,x);
%     y2 = filter(b2,a2,x);
%     y = y1+y2;
%     figure;
%     specgram(y, 512, 16000, hamming(400), []);
    audiowrite(newPath+filename,y,sampling_freq);
    clear x y filename
end