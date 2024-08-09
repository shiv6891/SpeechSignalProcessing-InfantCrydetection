close all; clear
% wts = importdata('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/Exp5_DNNCry/3_AcousticAnls_LrndFeat/saved_models/2Layers_ZFF/best_mdlwts_CV1.txt');
% wts = importdata('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/Exp5_DNNCry/3_AcousticAnls_LrndFeat/saved_models/2Layers_Cry/best_mdlwts_CV1.txt');
% wts = importdata('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/Exp5_DNNCry/3_AcousticAnls_LrndFeat/saved_models/30Jan_FiltSig_CNNtrain_2Layers/1_FilSig_ZFF_ZFFNet_1Pole/best_mdlwts_CV1.txt');
% wts = importdata('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/Exp5_DNNCry/3_AcousticAnls_LrndFeat/saved_models/30Jan_FiltSig_CNNtrain_2Layers/2_FilSig_Cry_CryNet_1Pole/best_mdlwts_CV1.txt');
% wts = importdata('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/Exp5_DNNCry/3_AcousticAnls_LrndFeat/saved_models/2Layers/FilSig_ZFF_ZFFNetCAS_3Pole/best_mdlwts_CV1.txt');

%wts = importdata('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/kf_nnetcry/exp/saved_files/conv1wts_CV_RawCry1_nnetCry.txt');

% ZFF Nets
% wts = importdata('/media/ssharma/My Passport/Data/Official/IDIAP/Work/Experiments/Exp5_DNNCry/3_AcousticAnls_LrndFeat/saved_models/13Jan_Layers_Inputs_All/ZFF/2Layers_ZFF/best_mdlwts_CV1.txt');
% wts = importdata('/media/ssharma/My Passport/Data/Official/IDIAP/Work/Experiments/Exp5_DNNCry/3_AcousticAnls_LrndFeat/saved_models/30Jan_FiltSig_CNNtrain_2Layers/1_FilSig_ZFF_ZFFNet_1Pole/best_mdlwts_CV1.txt');
% wts = importdata('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/ssharma/saved_models/2Layers/FilSig_ZFF_ZFFNetCAS_3Pole/best_mdlwts_CV1.txt');


wts = importdata('/media/ssharma/My Passport/Data/Official/IDIAP/Work/Experiments/Exp5_DNNCry/3_AcousticAnls_LrndFeat/saved_models/24Jan_Layers_Inputs_All/ZFF/4Layers_ZFF/best_mdlwts_1.txt');
% wts = importdata('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/kf_nnetcry/exp_wav_SNS/wav_subseg_1/best_mdlwts_CV1.txt');

wts2 = wts';
filters = 0;
N=4092;
freq=(0:N/2-1)*(16000/N);
nbFilters=size(wts2,1);
for i=1:nbFilters
    f = abs(fft(wts2(i,:),N));
    f=f(1:N/2);
    filters = filters + f;%/sum(f);
end
filters=filters/nbFilters;

figure 
f1 = plot(freq,filters, 'k', 'LineWidth',2);grid;
xlabel('freq (Hz)'); ylabel('|X[\omega]|');
title('CumFreqRes Exp-7a: ZFF\_IIR, kw=30, 4L')
title('CumFreqRes, ZFFBSS(16kw)\_ZFFNet1Poles(16kw, PA)')
% %% For multiple plots
f1 = plot(freq,filters, 'k', 'LineWidth',2);grid;hold on;
% f1 = plot(freq,filters, ':b', 'LineWidth',2);hold on;
f1 = plot(freq,filters, '--r', 'LineWidth',2);
xlabel('freq (Hz)'); ylabel('|X[\omega]|'); 
% title('CumFreqRes of CRY and ZFF input based training')
title('CumFreqRes, 2 L ZFF\\CryNet, 16 kw')
% % legend('ZFFNet', 'ZFF\_ZFFNet\_1Pole', 'ZFF\_ZFFNet\_3Poles')
% legend('CRYNet', 'CRY\_CRYNet\_1Pole', 'CRY\_CRYNet\_3Poles')
legend('CryNet', 'ZFFNet')
% % saveas(f1,'11_aZryNetZFFReso_bCFRZFF_cCFRCry_dReso_1Pole.jpg')
saveas(f1,'12_4Layers_ZFFBSS(16kw)_ZFFNet1Poles(16kw, PA)CFRF')