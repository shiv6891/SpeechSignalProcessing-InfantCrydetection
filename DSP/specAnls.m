% close all;
% clear all;clc
% [data,fs] = audioread('/idiap/home/ssharma/Shivam/Workstation/Work/Datasetup/ZFFOutput2/noSil/preProc2/Pain/S01_F_02d_sn1_c01_09_Pain_1.wav');
%[x1, fs] = audioread('/idiap/home/ssharma/Shivam/Workstation/Work/Datasetup/wav2/noSil/preProc2/Pain/S01_F_02d_sn1_c01_09_Pain_1.wav');
x = data1;
N=2048;
freq = [0:N/2]*fs/N;
%n1 = 0.741*fs;
% n1 = 0.750*fs;
% n2 = n1+159;
idx_frame=1252;
shift=160;
context=0;
n1=(idx_frame-1)*shift+1;
n2=n1+(2*context+1)*shift-1;
x_seg = x(n1:n2);
x_segd = [x_seg(1);diff(x_seg(1:end))];

% Compute FFT spectrum
Xw=fft(x_segd, N);
X_mag = abs(Xw);
figure
plot(freq,X_mag(1:N/2+1))
xlabel('frequency (Hz)')
ylabel('X(w)')
title('FFT for Frame no.'+string(idx_frame))
% Compute LP spectrum
lp_order = 16;
[freq,lpspectrum]=lpSpectrum(x, fs, idx_frame, lp_order,1,N);

figure
plot(freq,lpspectrum,'-','LineWidth',1)
xlabel('frequency (Hz)')
ylabel('LP spectrum')
title('LP Spectrum for Frame no.'+string(idx_frame))
% Compute spectrogram

% figure;
% specgram(data, 512, 16000, hamming(400), []);

function [freq,lpspec] = lpSpectrum(x, fs, idx, lporder, win, order)

% this routine computes the linear prediction coefficients and plots
% the lp specturm in the figure with number fignu and plottitle as the
% title, along with the fourier spectrum. The usage is as given below
%
% lpspec = lpSpectrum(data, lporder, win, order, sf, fignu, 'plottitle');
%
% where data is the short-time signal, lporder is the order of the linear
% predicition, win is 0 for rectangular window and 1 for Hamming window.
% order is the FFT order used during the computation of lp spectrum,
% sf is the sampling frequency the computed lp spectrum is plotted in 
% figure fignu with plottitle as the title.

data = x;

context = 0;
shift = 160;
%data = data(idx*160+1:idx*160+(2*context+1)*160);
data = data((idx-1)*shift+1:(idx-1)*shift+(2*context+1)*shift);
if win == 1
 data = data .* hamming(length(data));
end

% preemphasize to remove the spectral tilt due to glottal pulse spectrum.
difdata(1) = data(1);
difdata(2:length(data)) = diff(data);
if size(difdata, 2)>1
   difdata = difdata';
end

for n=1:order freq(n) = ((n-1) * fs)/(order); end

% Computation of lp Spectrum
a = lpc(difdata, lporder);
%lpspec = 1./abs(fft(a, order));
 lpspec = -20 * log10(abs(fft(a, order)));
% lpspec = abs(fft(a, order));
freq = freq(1:(order/2)+1);
lpspec = lpspec(1:(order/2)+1);

end
