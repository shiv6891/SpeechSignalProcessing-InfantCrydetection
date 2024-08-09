close all; clc;
clear all;
% Voice_Sample_Exp4_183 ms
% 11_EvrTre_Eng_M_Pop_CR
% 17_HatnOn_Eng_F_Pop_RI
% 22_RasRad_HiC_M_MadSar_Jas
[x, fs] = wavread('043. Toni Braxton - Yesterday_ex_spmu.wav');
% [x, fs] = audioread('Flute_ARRhm_KhneKo.mp3');

x = x(:, 1);%Taking out the excerpts

% t1 = ceil(1.94*fs);
% t2 = ceil(2.61*fs);
% N = 3*fs;+
% x = x(t1:t2);
fsize1 = 30;                                                                %   Autocorrelation
fshift1 = 10;                                                               %   Autocorrelation
fsize2 = 30;                                                                %   LP Residual
fshift2 = 10;                                                               %   LP Residual
dflag = 0;
plotFlag=0;
% Autocorrelation for Raw Signal
% [f01, xaxis1, t01, bsig1] = autocorr_V8b(x,fs,fsize1,fshift1,plotFlag, dflag);
[f01, xaxis1] = autocorr_V8bmedFilt(x,fs,fsize1,fshift1,0, dflag);
%Downsampling for Lp Residual
fs2 = 10000;
y = resample(x, fs2, fs);
y = y/max(y);
lporder = 12;
preempflag=1;
plotFlag=0;
%LP Residual
[residual,he,LPCoeffs] = computeResidual(y,fs2,fsize2,fshift2,lporder,preempflag,plotFlag);
plotFlag=0;
% Autocorrelation for LP Residual
% [f02, xaxis2, t02, bsig2] = autocorr_V8b(residual,fs2,fsize1,fshift1,plotFlag, dflag);
[f02, xaxis2] = autocorr_V8bmedFilt(residual,fs2,fsize1,fshift1,plotFlag, dflag);
plotFlag=0;
%Using ZFF

% Compute average pitch period of the utterance (in ms).
[avgt0, nc, edges]= computeWindowLength(x,fs,1, 0);

% Compute the zero-frequency filtered signal.
winLength = ceil(1.5*avgt0); % can be 2T0 also.
[zfssig, fs2]=zeroFrequencyFilter(x, fs, winLength);

% Compute instantaneous f0, t0 and slope of zero-crossings.
[f03,it0,slope,xaxis3] = computeF0andSlope(zfssig, fs2, 1);
% if0 in Hz, it0, it in seconds.



figure;
ax(1) = subplot(4, 1, 1);
plot([1:length(x)]./fs, x./max(x), 'k');
title('Fig. a: Input Music Mixture (W), Female, Fs = 48 KHz');
% xlim([0 length(x)./fs]);
xlim([4.1 5.8]);
xlabel('Time (s)');
ax(2) = subplot(4, 1, 2);
plot(xaxis1, f01, 'k.');
title('Fig. b: Using Autocorrelation: Frame Size: 30 ms, Frame Shift: 10 ms');
% ylim([0 400]);
% xlim([1/fs length(x)/fs]);
% ylim([0 2000]);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
% xlim([60 140]);
ax(3) = subplot(4, 1, 3);
plot(xaxis2, f02, 'k.');
title('Fig. c: Using ACF of LPR ~(FSize: 30 ms, FShift: 10 ms), RDsam 10 KHz');
% ylim([0 400]);
% xlim([1/fs length(x)/fs]);
% ylim([0 2000]);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ax(4) = subplot(4, 1, 4);
plot(xaxis3,f03, 'k.');
ylim([0 400]);
title('Fig. d: Using ZFF');
% xlim([1/fs length(x)/fs]);
% ylim([0 3000]);
xlabel('Time (s)');
ylabel('Frequency (Hz)');

linkaxes(ax, 'x');