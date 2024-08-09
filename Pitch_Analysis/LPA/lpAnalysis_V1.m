%**************************************************************************
%***********************       lpAnalysis_V1   ****************************
%**************************************************************************
%   The current code does the LP Analysis and performs the following
%   1. Gets the LP Spectrum using all pole model
%   2. Gets the first three formant frequencies by standard peak detetction
%   algorithm
%**************************************************************************
%   Created by: Sergio Teran, EEN 540 Acoustic Properties of Speech Source Code
%   Project 1
%   Source:     https://sites.google.com/site/een540project1/Home/matlab-source-code
%   Updates by: Shivam Sharma
%   Update1:    Added the peak detecttion for the Formant frequencies
%   Update2:    Added code for outputting first three formants
%   Update3:    15/06/2016  Modification: unwindowed before FFT
%**************************************************************************
% Input:  x:      Input Signal
%         fs:     Sampling frequency
%         chunk:  Window Size (Chunk-wise windowing required window sized chunking of the signal to be be windowed)
%                   Also signal size
%         plotFlag: If 1, Gives the figure having: Input signal, Magntude
%         spectrum, LP Spectrum
% Output: forfr:  First n Formant Frequencies (Can be specified at the Line 98 and 99)
%         lspec:  Smoothed LP spectrum
%**************************************************************************
% clear all; close all; clc;
% [x,fs,bits] = wavread('15_M_Sa.wav');
% x = x(:,1);
% 
% N1 = 0.289.*fs;
% chunk = 0.030*fs;
% xSig = x(N1:N1+chunk-1);  
% x = xSig;
%**************************************************************************



function [forfr, lspec] = lpAnalysis_V1(x, fs, chunk, plotFlag, p)

N = 1024;                                                                   %   FFT Points
N_2 = ceil(N/2); 

% t = 0:1/fs:(length(x)-1)/fs;
t = [1:length(x)]./fs;
if (plotFlag == 1)
figure(1);
ax(1) = subplot(4,1,1);
plot(t,x, 'k');
title('Time Waveform of the note signal'); xlabel('Time (s)');ylabel('Amplitude') 
end
win1 = hamming(chunk);
win1 = win1';

%Magnitude Spectrum
%   Uncomment below for windowing
mag = abs(fft(x*win1,N));
% mag = abs(fft(x,N));

mag = mag(1:N_2); 
bin_vals = [0 : N-1];
freq = bin_vals*fs/N;
if (plotFlag ==1)
bx(1) = subplot(4,1,2);
plot(freq(1:N_2),db(mag/N), 'k');      % divide by 1024 to normalize after fourier transform
axis tight; grid on; %title('Magnitude Spectrum');
xlim([0 5000]);
ylim([-120 0]);
xlabel('Frequency (Hz)'); ylabel('|X(f)| (dB)');
hold on
end

%Smoothing - Linear Prediction
%   Uncomment the below to have the default: fs/1000+4 parameter
% p=fs/1000 + 4;
[a,g]=lpc(x,p);
[lspec, lpfr] = freqz(g,a,freq,fs);
lpLogsp = 20*log10(abs(lspec));
if (plotFlag ==1)
bx(2) = subplot(4,1,2);
plot(freq, lpLogsp,'k');

% xlim([0 6000]);
% axis tight;
title('Smoothed Spectral Envelope and Magnitude Spectrum (Fs: 10 KHz, LP Order: 12)');
end
hold on
    % Get the peaks from the smoothed signal
        y1 = [diff(lpLogsp) > 0]; 	% Positive y1 indicates increasing trend.
        y2 = [diff(lpLogsp) <= 0];	% Positive y2 indicates decreasing trend.

	% Identify 1-0 transitions in y1, or identify 0-1 transition in y2.
        [locPeaks] = find((y1(1:length(y1)-1) + y2(2:length(y2))) == 2);
        if isempty(locPeaks) == 0
            locPeaks = locPeaks(:) + ones(length(locPeaks),1);
        end
        
        peakVal = lpLogsp(locPeaks);
        forPeakIn = locPeaks(1:5);                                          %   Change to desired number (n) for the fist n peaks
        forPeakVal = peakVal(1:5);
        forfr = lpfr(forPeakIn);
if (plotFlag ==1)    
bx(3) = subplot(4,1,2);
plot(forfr, forPeakVal,'ro');
% linkaxes(ax, 'x');
end
end