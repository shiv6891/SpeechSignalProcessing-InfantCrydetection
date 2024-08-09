close all; clc; clear all;

% Voice_Sample_Exp4_183 ms

[x, fs] = audioread('S13_F_01m_sn1_c20_31_Pain.wav');
% [x, fs] = audioread('S21_F_28m_sn1_c01_13_Anxt.wav');
% For MP3 versions

x = x(:, 1);%Taking out the excerpts


% Get the spectrogram

[t, f, S] = spect(x, fs);

[vs,zo]=vadsohn(x,fs, 't');
xaxis0 = vs(:, 2);
vas= vs(:, 3);
vas = vas';

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
p.sr = fs;
%--------------------------------------------------------------------------
% Pitch Extraction (Ground truth for Pitch contour) using YIN
%--------------------------------------------------------------------------
[nframes, fsr, f0, good, best, r] = yin(x,p); 



%--------------------------------------------------------------------------
%% Autocorrelation for Raw Signal
plotFlag = 0;
% [f01, xaxis1, t01, bsig1] = autocorr_avt0_V8b(x,fs,fsize1,fshift1,plotFlag, dflag);
[f01, xaxis1] = autocorr_V8bmedFilt(x,fs,fsize1,fshift1,plotFlag, dflag);
% autocorr_V8bmedFilt
%__________________________________________________________________________
% % Masking the F0 contour with the Voice Ativity Detection output
f01v = nan(1, length(f01));
vind = find(vas);
f01v(vind) = f01(vind);
%__________________________________________________________________________
% %% Autocorrelation of the LP Residual
% -------------------------------------------------------------------------
% % Downsampling for Lp Residual
% fs2 = 10000;
% y = resample(x, fs2, fs);
% y = y/max(y);
% lporder = 12;
% preempflag=1;
% plotFlag=0;
% %LP Residual
% [residual,he,LPCoeffs] = computeResidual(y,fs2,fsize2,fshift2,lporder,preempflag,plotFlag);
% plotFlag=0;
% Autocorrelation for LP Residual
% [f02, xaxis2, t02, bsig2] = autocorr_avt0_V8(residual,fs2,fsize1,fshift1,plotFlag, dflag);
% [f02, xaxis2] = autocorr_V8bmedFilt(residual,fs2,fsize1,fshift1,plotFlag, dflag);
% f02v = nan(1, length(f02));
% vind = find(vas);
% f02v(vind) = f02(vind);
% 
% plotFlag=0;
%--------------------------------------------------------------------------
%%  Using ZFF

% % Compute average pitch period of the utterance (in ms).
% [avgt0, nc, edges]= computeWindowLength(x,fs,1, 0);
% 
% % Compute the zero-frequency filtered signal.
% winLength = ceil(1.5*avgt0); % can be 2T0 also.
% [zfssig, fs2]=zeroFrequencyFilter(x, fs, winLength);
% 
% % Compute instantaneous f0, t0 and slope of zero-crossings.
% [f03,it0,slope,xaxis3] = computeF0andSlope(zfssig, fs2, 1);
% % if0 in Hz, it0, it in seconds.
% 
% 
% % Computing the slope
% [m1,m2,p1,p2,y,fs] = slopeOfZC(x, fs, winLength, 0);

%   -----------------------------------------------------------------------
%% Plots and Figures
% title('Fig. a: Input Music Mixture, Female voice, Fs = 48 KHz');
% title('Fig. b: F_0 Contour using Autocorrelation: Frame Size: 30 ms, Frame Shift: 10 ms');
% title('Fig. c: Using Autocorrelation (Frame Size: 30 ms, Frame Shift: 10 ms) of LP Residual (Frame Size: 30 ms, Frame Shift: 10 ms), Raw Downsampled to 10 KHz');
% title('Fig. c: F_0 Contour using ZFF');
% title('Fig. d: SOE using ZFF');
%   -----------------------------------------------------------------------
% figure1 = figure('Position', [100, 100, 1024, 1200]);
figure;

ax(1) = subplot(3, 1, 1);
% --------------------------------------------------------------------------
% Plot Set 1
plot([1:length(x)]./fs, x./max(x), 'k');
hold on;
% plot([1:length(s)]/fs, vad/1.1,'r' ); Plot from VKM sir's code
plot(xaxis0, vas, 'r',  'LineWidth',1.5); % plot from Voice Box: M Brooks

ylim([-1.5 1.5]);
title('(a). Input Cry Signal, Fs = 48 KHz', 'FontName', 'Times New Roman', 'FontSize', 14);
set(gca, 'XTickLabelMode', 'Manual')
set(gca, 'XTick', [])
xlim([1/fs length(x)/fs]);
% xlim([0 3]);
% xlabel('Time (s)', 'FontName', 'SansSerif');
% % --------------------------------------------------------------------------
% % Plot Set 2 - Function plot 
% % --------------------------------------------------------------------------
%     plot((nv+nd+[0 nr*ni])/fs,[qq.pr qq.pr],'r:',(nv+nd+ni*nj/2+(0:nw-1)*ni*nj)/fs,max(reshape(prsp(1:nw*nj),nj,[]),[],1).','b-' );
%     set(gca,'ylim',[-0.05 1.05]);
%     xlabel('Time (s)');
%     ylabel('Pr(speech)');
%     
%     hold on;
%     plot((nv+(1:ns))/fs,s);
%     ylabel('Speech');
%     title('Sohn VAD');
%  % --------------------------------------------------------------------------
%%Spectrogram subplot
ax(2) = subplot(3, 1, 2);

surf(t, f, S)
colormap(bone)
shading interp
axis tight
box on
view(0, 90)
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
% xlabel('Time, s')
ylabel('Frequency, Hz', 'FontName', 'Times New Roman', 'FontSize', 14)
ylim([0 6000])
set(gca, 'XTickLabelMode', 'Manual')
set(gca, 'XTick', [])
title('(b). Narrow band spectrogram')

% handl = colorbar;
% set(handl, 'FontName', 'Times New Roman', 'FontSize', 14)
% ylabel(handl, 'Magnitude, dB')


%%ACf subplots
ax(3) = subplot(3, 1, 3);
% hold on
% -------------------------------------------------------------------------
% YIN Pitch Plot
% -------------------------------------------------------------------------
% plot((1:nframes)/fsr, f0, 'y', (1:nframes)/fsr, good, 'g',
% (1:nframes)/fsr, best, 'b');   Original Plot
%  plot((1:nframes)/fsr, best, 'k--', 'LineWidth', 1.5);  %hold on;
%  %Revised plot 2
% plot((1:nframes)/fsr, f0, 'y', (1:nframes)/fsr, good, 'g', (1:nframes)/fsr, best, 'b'); hold on;
plot(xaxis1, f01v, 'k.');%, 'LineWidth',1.5);
	lo = max(min(f0),min(good)); hi=min(max(f0),max(good));
	set(gca, 'ylim', [lo-0.5; hi+0.5]);     
	%set(gca, 'xlim', [1,nframes]/fsr);
% 	set(get(gca,'ylabel'), 'string', 'Oct. re: 440 Hz');
% 	set(get(gca,'xlabel'), 'string', 's');
%---------------------------------------------------------------------------
title('(c). F_0 Contour using Autocorrelation', 'FontName', 'Times New Roman', 'FontSize', 14);
% xlim([2.275 2.997]);
% ylim([0 700]);
xlabel('Time (s)', 'FontName', 'Times New Roman', 'FontSize', 14);
ylabel('F_0 (Hz)', 'FontName', 'Times New Roman', 'FontSize', 14);
ylim([0 1000])
x1t = get(gca, 'XTick');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
y2t = get(gca, 'YTick');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
% xlim([60 140]);
% %% LP Residual Plot
% 
% ax(3) = subplot(3, 1, 3);
% plot((1:nframes)/fsr, f0, 'y', (1:nframes)/fsr, good, 'g', (1:nframes)/fsr, best, 'b'); hold on;
% plot(xaxis2, f02v, 'k.');
% title('Fig. c: F_0 Contour using ACF of LPR: FSize: 30 ms, FShift: 10 ms, Fs: 10 KHz', 'FontName', 'SansSerif');
% xlabel('Time (s)', 'FontName', 'SansSerif');
% ylabel('F_0 (Hz)', 'FontName', 'SansSerif');
% % hold on;
% 
% % % -------------------------------------------------------------------------
% % % YIN Pitch Plot
% % % -------------------------------------------------------------------------
% % plot((1:nframes)/fsr, best, 'r');
% 	%lo = max(min(f0),min(good)); hi=min(max(f0),max(good));
% 	set(gca, 'ylim', [lo-0.5; hi+0.5]); 
% 	set(gca, 'xlim', [1,nframes]/fsr);
% % % 	set(get(gca,'ylabel'), 'string', 'Oct. re: 440 Hz');
% % 	set(get(gca,'xlabel'), 'string', 's');
% % %---------------------------------------------------------------------------
% % % xlim([1/fs length(x)/fs]);
% % ylim([0 700]);
% 
% xlabel('Time (s)', 'FontName', 'SansSerif');
% ylabel('F_0 (Hz)', 'FontName', 'SansSerif');
% % %---------------------------------------------------------------------------
% % %---------------------------------------------------------------------------
% % %---------------------------------------------------------------------------
% %% ZFF Pitch conntour plots
% ax(4) = subplot(4, 1, 3);
% 
% 
% title('Fig. c: F_0 Contour using ZFF', 'FontName', 'SansSerif');
% % hold on
% % -------------------------------------------------------------------------
% % YIN Pitch Plot
% % -------------------------------------------------------------------------
% % plot((1:nframes)/fsr, best, 'r', 'LineWidth',2);
% % plot((1:nframes)/fsr, best, 'r--', 'LineWidth',1.5); %hold on;
% plot((1:nframes)/fsr, f0, 'y', (1:nframes)/fsr, good, 'g', (1:nframes)/fsr, best, 'b'); hold on;
% plot(xaxis3, f03, 'k--'); %'LineWidth',1.5);
% % 	lo = max(min(f0),min(good)); hi=min(max(f0),max(good));
% 	%set(gca, 'ylim', [lo-0.5; hi+0.5]); 
% 	set(gca, 'xlim', [1,nframes]/fsr);
% % 	set(get(gca,'ylabel'), 'string', 'Oct. re: 440 Hz');
% % 	set(get(gca,'xlabel'), 'string', 's');
% %---------------------------------------------------------------------------
% % xlim([1/fs length(x)/fs]);
% % ylim([0 2000]);
% ylim([0 500]);
% % xlim([1/fs length(x)/fs]);
% % ylim([0 3000]);
% xlabel('Time (s)', 'FontName', 'SansSerif');
% ylabel('F_0 (Hz)', 'FontName', 'SansSerif');
% ax(5) = subplot(4, 1, 4);
% stem(p1, m1,'k');grid;
% % xlim([1/fs length(y)/fs]);
% % stem(it,slope./max(slope), 'k');
% title('Fig. d: SOE using ZFF', 'FontName', 'SansSerif');
% xlabel('Time (s)', 'FontName', 'SansSerif');
% ylabel('SOE', 'FontName', 'SansSerif');
%%Link the axes finally

linkaxes(ax, 'x');