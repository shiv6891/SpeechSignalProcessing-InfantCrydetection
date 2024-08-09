close all; clc; clear ;

% Voice_Sample_Exp4_183 ms

[x, fs] = audioread('S01_F_02d_sn1_c01_09_Pain.wav');
x = x(:, 1);%Taking out the excerpts
% Get the spectrogram
[t, f, S] = spect(x, fs);
% Get the VAD
[vs,zo]=vadsohn(x,fs, 't');
xaxis0 = vs(:, 2);
vas= vs(:, 3);
vas = vas';
% Windowing parameters
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
% [nframes, fsr, f0, good, best, r] = yin(x,p); 
%--------------------------------------------------------------------------
%% Autocorrelation for Raw Signal
plotFlag = 0;
% [f01, xaxis1, t01, bsig1] = autocorr_avt0_V8b(x,fs,fsize1,fshift1,plotFlag, dflag);
[f01, xaxis1] = autocorr_V8bmedFilt(x,fs,fsize1,fshift1,plotFlag, dflag);
% autocorr_V8bmedFilt
%__________________________________________________________________________
% % Masking the F0 contour with the Voice Activity Detection output
f01v = nan(1, length(f01));
vind = find(vas);
f01v(vind) = f01(vind);

%Computing I and II order derivatives
w = 4;
% f01b: Takes care of the Nan's for delta processing
f01b = f01v;
nanInd = isnan(f01v);
f01b(nanInd) = 0;
dF = deltas(f01b, w);
ddF = deltas(dF, w);
%% Plots and Figures
% title('Fig. a: Input Music Mixture, Female voice, Fs = 48 KHz');
% title('Fig. b: F_0 Contour using Autocorrelation: Frame Size: 30 ms, Frame Shift: 10 ms');
% title('Fig. c: Using Autocorrelation (Frame Size: 30 ms, Frame Shift: 10 ms) of LP Residual (Frame Size: 30 ms, Frame Shift: 10 ms), Raw Downsampled to 10 KHz');
% title('Fig. c: F_0 Contour using ZFF');
% title('Fig. d: SOE using ZFF');
%   -----------------------------------------------------------------------
figure;
ax(1) = subplot(4, 1, 1);
% --------------------------------------------------------------------------
% Plot Set 1
plot([1:length(x)]./fs, x./max(x), 'k');
hold on;
% plot([1:length(s)]/fs, vad/1.1,'r' ); Plot from VKM sir's code
plot(xaxis0, vas, 'r',  'LineWidth',1.5); % plot from Voice Box: M Brooks

ylim([-1.5 1.5]);
% title('(b). F_0 Contour using Autocorrelation', 'FontName', 'Times New Roman', 'FontSize', 14);
% title('(a). Input Cry Signal, Fs = 48 KHz', 'FontName', 'Times New Roman', 'FontSize', 14);
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

%%ACf subplots
% 1. Moving average 
ax(2) = subplot(4, 1, 2);
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
% 	lo = max(min(f01v),min(good)); hi=min(max(f0),max(good));
% 	set(gca, 'ylim', [lo-0.5; hi+0.5]);     
	%set(gca, 'xlim', [1,nframes]/fsr);
% 	set(get(gca,'ylabel'), 'string', 'Oct. re: 440 Hz');
% 	set(get(gca,'xlabel'), 'string', 's');
%---------------------------------------------------------------------------
title('(b). F_0 Contour using Autocorrelation', 'FontName', 'Times New Roman', 'FontSize', 14);
% xlim([2.275 2.997]);
% ylim([0 700]);
xlabel('Time (s)', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('F_0 (Hz)', 'FontName', 'Times New Roman', 'FontSize', 12);
ylim([0 min(1000, max(f01v))]);
x1t = get(gca, 'XTick');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10)
y2t = get(gca, 'YTick');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10)
xlim([1/fs length(x)/fs]);
% xlim([60 140]);

% 3. Deltas 
ax(3) = subplot(4, 1, 3);
% hold on
% -------------------------------------------------------------------------
% YIN Pitch Plot
% -------------------------------------------------------------------------
% plot((1:nframes)/fsr, f0, 'y', (1:nframes)/fsr, good, 'g',
% (1:nframes)/fsr, best, 'b');   Original Plot
%  plot((1:nframes)/fsr, best, 'k--', 'LineWidth', 1.5);  %hold on;
%  %Revised plot 2
% plot((1:nframes)/fsr, f0, 'y', (1:nframes)/fsr, good, 'g', (1:nframes)/fsr, best, 'b'); hold on;
plot(xaxis1, diff([0 dF]), 'k', 'LineWidth',1.5);
% 	lo = max(min(f01v),min(good)); hi=min(max(f0),max(good));
% 	set(gca, 'ylim', [lo-0.5; hi+0.5]);     
	%set(gca, 'xlim', [1,nframes]/fsr);
% 	set(get(gca,'ylabel'), 'string', 'Oct. re: 440 Hz');
% 	set(get(gca,'xlabel'), 'string', 's');
%---------------------------------------------------------------------------
title('(c). \Delta F_0', 'FontName', 'Times New Roman', 'FontSize', 14);
% xlim([2.275 2.997]);
ylim([0 500]);
xlabel('Time (s)', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('F_0 (Hz)', 'FontName', 'Times New Roman', 'FontSize', 12);
% ylim([0 1000])
x1t = get(gca, 'XTick');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10)
y2t = get(gca, 'YTick');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10)
xlim([1/fs length(x)/fs]);
% xlim([60 140]);

% 4. Delta-delta 
ax(4) = subplot(4, 1, 4);
% hold on
% -------------------------------------------------------------------------
% YIN Pitch Plot
% -------------------------------------------------------------------------
% plot((1:nframes)/fsr, f0, 'y', (1:nframes)/fsr, good, 'g',
% (1:nframes)/fsr, best, 'b');   Original Plot
%  plot((1:nframes)/fsr, best, 'k--', 'LineWidth', 1.5);  %hold on;
%  %Revised plot 2
% plot((1:nframes)/fsr, f0, 'y', (1:nframes)/fsr, good, 'g', (1:nframes)/fsr, best, 'b'); hold on;
plot(xaxis1, diff([0 ddF]), 'k.', 'LineWidth',1.5);
% 	lo = max(min(f01v),min(good)); hi=min(max(f0),max(good));
% 	set(gca, 'ylim', [lo-0.5; hi+0.5]);     
	%set(gca, 'xlim', [1,nframes]/fsr);
% 	set(get(gca,'ylabel'), 'string', 'Oct. re: 440 Hz');
% 	set(get(gca,'xlabel'), 'string', 's');
%---------------------------------------------------------------------------
title('(d). \Delta\Delta F_0', 'FontName', 'Times New Roman', 'FontSize', 14);
% xlim([2.275 2.997]);
% ylim([0 700]);
xlabel('Time (s)', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('F_0 (Hz)', 'FontName', 'Times New Roman', 'FontSize', 12);
ylim([0 500])
x1t = get(gca, 'XTick');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10)
y2t = get(gca, 'YTick');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 10)
xlim([1/fs length(x)/fs]);
% xlim([60 140]);
%%Link the axes finally
linkaxes(ax, 'x');