%   Main File to run the test for ACF
close all; clc;
clear all;
% Voice_Sample_Exp4_183 ms
% 11_EvrTre_Eng_M_Pop_CR
% 17_HatnOn_Eng_F_Pop_RI
% 22_RasRad_HiC_M_MadSar_Jas
[x, fs] = wavread('Voice_Sample_Exp4_183 ms.wav');
% [x, fs] = audioread('Xylophone.hardrubber.ff.F4.stereo.aif');

x = x(:, 1);%Taking out the excerpts
% t = 3;
% N = 3*fs;
% x = x(1:N);
fsize1 = 30;                                                                %   Autocorrelation
fshift1 = 10;                                                               %   Autocorrelation
fsize2 = 30;                                                                %   LP Residual
fshift2 = 10;                                                               %   LP Residual
dflag = 0;
plotFlag=4;
% Autocorrelation for Raw Signal
[f01, xaxis1, t01, bsig1] = autocorr_V8b(x,fs,fsize1,fshift1,plotFlag, dflag);
plotFlag=0;
[f02, xaxis2, t02] = autocorrF0MedF_V1(x,fs,fsize2,fshift2,plotFlag);


%**************************************************************************
% Plots and figures
figure;
ax(1) = subplot(3, 1, 1);
plot([1:length(x)]./fs, x, 'k');
title('Fig. a: Input Music Mixture (W), Male, Fs = 48 KHz');
xlim([1/fs length(x)/fs]);
%xlim([60 140]);
xlabel('Time (s)');
ax(2) = subplot(3, 1, 2);
xlim([1/fs length(x)/fs]);
plot(xaxis1, f01, 'k.');
title('Fig. b: Using Autocorrelation: Frame Size: 30 ms, Frame Shift: 10 ms');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
% xlim([60 140]);
ax(3) = subplot(3, 1, 3);
plot(xaxis2, f02, 'k.');
xlim([1/fs length(x)/fs]);
% xlim([60 140]);
title('Fig. c: Using Autocorrelation: Frame Size: 30 ms, Frame Shift: 10 ms');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
linkaxes(ax, 'x');