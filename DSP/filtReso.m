close all; clear
% wts = importdata('/media/ssharma/My Passport/Data/Official/IDIAP/Work/Experiments/Exp5_DNNCry/3_AcousticAnls_LrndFeat/saved_models/13Jan_Layers_Inputs_All/ZFF/2Layers_ZFF/best_mdlwts_CV1.txt');
% wts = importdata('/media/ssharma/My Passport/Data/Official/IDIAP/Work/Experiments/Exp5_DNNCry/3_AcousticAnls_LrndFeat/saved_models/13Jan_Layers_Inputs_All/ZFF/2Layers_ZFF/best_mdlwts_CV1.txt');
wts = importdata('/media/ssharma/My Passport/Data/Official/IDIAP/Work/Experiments/Exp5_DNNCry/3_AcousticAnls_LrndFeat/saved_models/13Jan_Layers_Inputs_All/Cry/4Layers_Cry/best_mdlwts_CV1.txt');
%wts = importdata('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/kf_nnetcry/exp/saved_files/conv1wts_CV_RawCry1_nnetCry.txt');
wts2 = wts';
filters = 0;
N=4096;
freq=(0:N/2-1)*(16000/N);
nbFilters=size(wts2,1);
for i=1:nbFilters
    f = abs(fft(wts2(i,:),N));
    f=f(1:N/2);
    filters = filters + f;%/sum(f);
end
% filters=20*log10(filters/nbFilters);
filters=filters/nbFilters;

figure
f1 = plot(freq,filters,'LineWidth',2);grid;hold on 
xlabel('Hz')

%% Working out a resonator
%%% THIS IS A CODE TO DESIGN RESONATORS %%% 
% -------------------------------------------------------------------------
% % ZFFNet Pole1
w1c=1340;
w1l=843.8;
w1h=1871;

w2c=3254;
% w2l=843.8;
% w2h=1871;
rO_2 = 0.8;

w3c=6965;
w3l=6266;
w3h=7727;
% -------------------------------------------------------------------------
% % % % CryNet Pole1
w1c=250;
% % w2l=843.8;
% % w2h=1871;
rO = 0.320;

w2c=3004;
w2l=2020;
w2h=3938;

w3c=6336;
% w3l=6266;
% w3h=7727;
rO_3 = 0.62;





sampling_freq = 16000; % (in Hz) samplingfrequency
central_freq = w1c; % (in Hz) central frequency of resonator
rO = exp(-pi*(w1h-w1l)*1/sampling_freq); %Bandwidth of the resonator
% rO = 0.99; %Bandwidth of the resonator
dft_points = 2048; % resolution of the filter


radian_freq = (central_freq/sampling_freq)*2*pi; % normalized central freq
poly_Num = [1]; % numerator polynomial 
poly_Den = [1 -2*rO*cos(radian_freq) rO.^2]; % denominator polynomial 
[resonator_response, freq_axis] = freqz(poly_Num,poly_Den,dft_points); % generating filter response
[anti_resonator_response, ~] = freqz(poly_Den,poly_Num,dft_points); % generating filter response

%%%%%%%%%% FOR MORE RESONATORS 
central_freq_2 = w2c; % (in Hz) central frequency of resonator
% rO_2 = exp(-pi*(w2h-w2l)*1/sampling_freq); %Bandwidth of the resonator
% rO_2 = 0.9;
radian_freq_2 = (central_freq_2/sampling_freq)*2*pi; % normalized central freq
poly_Num_2 = [1]; % numerator polynomial 
poly_Den_2 = [1 -2*rO_2*cos(radian_freq_2) rO_2.^2]; % denominator polynomial 
[resonator_response_2, ~] = freqz(poly_Num_2,poly_Den_2,dft_points); % generating filter response
[anti_resonator_response_2, ~] = freqz(poly_Den_2,poly_Num_2,dft_points); % generating filter response

central_freq_3 = w3c; % (in Hz) central frequency of resonator
rO_3 = exp(-pi*(w3h-w3l)*1/sampling_freq)+0.0850; %Bandwidth of the resonator
radian_freq_3 = (central_freq_3/sampling_freq)*2*pi; % normalized central freq
poly_Num_3 = [1]; % numerator polynomial 
poly_Den_3 = [1 -2*rO_3*cos(radian_freq_3) rO_3.^2]; % denominator polynomial 
[resonator_response_3, ~] = freqz(poly_Num_3,poly_Den_3,dft_points); % generating filter response
[anti_resonator_response_3, ~] = freqz(poly_Den_3,poly_Num_3,dft_points); % generating filter response

% res_additive_response = resonator_response_2+ resonator_response;
res_multiplicative_response = resonator_response_3.*resonator_response_2.*resonator_response;

figure; 
% subplot(2,1,1)
% plot(freq_axis*sampling_freq/(2*pi), abs(res_additive_response),'k','LineWidth',2);hold on; grid; 
% ylabel('|H(\omega)|'); xlabel('freq (Hz)');
% title('additive response of resonators');
% subplot(2,1,2);
f1 = plot(freq_axis*sampling_freq/(2*pi), abs(res_multiplicative_response),':k','LineWidth',2);hold on; grid; 
xlabel('freq (Hz)'); ylabel('|X[k]|'); 
title('multiplicative response of resonators');
%%
figure;
zplane(poly_Num, poly_Den); hold on;grid;
zplane(poly_Num_2, poly_Den_2); hold on;
% zplane(poly_Num_3, poly_Den_3); hold on;
xlim([-3 3]);ylim([-1.2 1.2]);

%% Filtering the data
filename = '/idiap/home/ssharma/Shivam/Workstation/Work/Datasetup/wav2/noSil/preProc2/Pain/S01_F_02d_sn1_c01_09_Pain_1.wav';
filename = '/media/ssharma/My Passport/Data/Official/IDIAP/Work/Datasetup/wav2/noSil/FilSig_Cry_CryNet_1Pole/1_pp2_SFF_3004H_sameBW/Pain/S01_F_02d_sn1_c01_09_Pain_1.wav';
[x,fs] = audioread(filename);
x=(x-mean(x))/std(x);
figure;
specgram(x, 512, 16000, hamming(400), []);hold on;
title('Spectrogram of raw cry input')
b0 = 1;
b1 = [1];
b2 = [1];
b3 = [1];
a1 = [1 -2*rO*cos(radian_freq) rO.^2];
a2 = [1 -2*rO_2*cos(radian_freq_2) rO_2.^2];
a3 = [1 -2*rO_3*cos(radian_freq_3) rO_3.^2];
b = b0*conv(conv(b1,b2), b3);
a = conv(conv(a1,a2),a3);
[res2, fr2] = freqz(b0*b2,a2,dft_points);
[res, fr] = freqz(b,a,dft_points);

% figure;plot(freq_axis*sampling_freq/(2*pi), 20*log10(abs(resonator_response)),'k','LineWidth',2);hold on; grid; 
figure;
f1 = plot(freq,filters, 'k', 'LineWidth',2);grid;hold on 
f1 = plot(freq_axis*sampling_freq/(2*pi), abs(res2),'--r','LineWidth',2);hold on; 
f1 = plot(fr*sampling_freq/(2*pi), abs(res),':b','LineWidth',2);hold on; 
% f1 = plot(fr*sampling_freq/(2*pi), abs(res),'--r','LineWidth',2);hold on; grid; 

xlabel('freq (Hz)'); ylabel('|X[\omega]|'); 
% legend('F_{cum}*Reso', 'ZFFNet', 'CryNet', 'Resonator')
legend('F_{cum} CRYNet', 'Reso\_1Pole', 'Reso\_3Poles')
title('Overlapping magnitude spectrums of F_{cum}CryNet and Resonators')
saveas(f1,'4_aCRY_CRYNet_Reso013_V2.jpg')
y = filter(b,a,x);
figure;
specgram(y, 512, 16000, hamming(400), []);
title('Spectrogram of filtered cry input')



