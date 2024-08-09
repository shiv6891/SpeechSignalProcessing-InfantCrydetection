% Obesrvation plot for Source Excitation and System characteristics as below:
% 1. F0Dev
% 2. F0Mean
% 3. SSERat 4:2
% 4. deltaMFCCdev
% Purpose: Primarily being done for the Journal observation set.

% 1. S15_F_05m_sn1_c01_07_Pain
% 2. S44_M_09m_sn1_c04_11_Envr
close all; clc; clear;
cryFile = 'S44_M_09m_sn1_c04_11_Envr.wav';
[x, fs] = audioread(cryFile);
% [x, fs] = audioread('S21_F_28m_sn1_c01_13_Anxt.wav');
% For MP3 versions

x = x(:, 1);%Taking out the excerpts

[vs,zo]=vadsohn(x,fs, 't');
xaxis0 = vs(:, 2);
vas= vs(:, 3);
vas = vas';

fsize1 = 30;                                                                %   Autocorrelation
fshift1 = 10;                                                               %   Autocorrelation
fsize2 = 30;                                                                %   LP Residual
fshift2 = 10;                                                               %   LP Residual
dflag = 0;
plotFlag=0;
p.sr = fs;

[nframes, fsr, f0, good, best, r] = yin(x,p); 

plotFlag = 0;
% [f01, xaxis1, t01, bsig1] = autocorr_avt0_V8b(x,fs,fsize1,fshift1,plotFlag, dflag);
[f01, xaxis1] = autocorr_V8bmedFilt(x,fs,fsize1,fshift1,plotFlag, dflag);

f01v = nan(1, length(f01));
vind = find(vas);
f01v(vind) = f01(vind);

%--------------------------------------------------------------------------
% Getting parameters for Cry Unit level plotting
%--------------------------------------------------------------------------
[cryMeanf0, cryDevf0, caseMedf0, caseMedDevf0, NDevf0, f01v, xaxis1, begP, endP] = F0Stats_Med(cryFile);
% Code for the cry unit level processing
cT = 5*(begP+endP); % cT: Cry Time vector
cTs = cT/1000; % Cry Time vector in seconds
err=cryDevf0;
% %--------------------------------------------------------------------------
% % SSE inclusion
%--------------------------------------------------------------------------
% Pain
% SSE_42 = [5.242636552,	93.39787057,	80.14729755,	26.68851394,	83.38220549,	5.255885028,	3.980244882,	4.27899063,	9.926862901,	12.05861885];
% % Envr
SSE_42 = [4.195344283,	2.570536713,	0.436929246,	0.1275926,  0.888680368,	1.766859173,	0.391157024,	0.567957052,	1.008011703,	5.980926342,	34.60702457,	2.482260159,	0.084788441,	1.951568747,	0.50035168,	4.595085768,	0.753976051];
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Delta MFCC deviation - Cry Unit - wise
%--------------------------------------------------------------------------
% Pain
% dMFCCd = [1.28358317,	1.118599681,	1.171324889,	1.62393906,	1.696666357,	2.760175666,	2.198410927,	1.821397532,	2.033301853,	2.025683586,	2.061010862,	2.073751333,	1.898383663];
% Envr
dMFCCd = [0.45832426,	0.800869527,	1.07311059,	0.98133836,	1.326048002,	1.525534475,	1.566630403,	1.571713082,	1.389250744,	1.567629977,	1.518093338,	2.348341107,	1.486920846];
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% Plots
%--------------------------------------------------------------------------
figure;
ax(1) = subplot(4, 1, 1);
% -------------------------------
% Plot Set 1
plot([1:length(x)]./fs, x./max(x), 'k');
hold on;
% plot([1:length(s)]/fs, vad/1.1,'r' ); Plot from VKM sir's code
plot(xaxis0, vas, 'r',  'LineWidth',1.5); % plot from Voice Box: M Brooks

ylim([-1.5 1.5]);
y2t = get(gca, 'YTick');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12)
xlim([1/fs length(x)/fs]);
% title('(a). Input Cry Signal, Fs = 48 KHz', 'FontName', 'Times New Roman', 'FontSize', 12);
set(gca, 'XTickLabelMode', 'Manual')
set(gca, 'XTick', [])
xlim([1/fs length(x)/fs]);
l1 = legend('\bf(a) Input cry signal', 'Location', 'northoutside');
legend('boxoff')
l1.FontSize = 12;


%%ACf subplots
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
plot(xaxis1, f01v, 'k.');hold on%, 'LineWidth',1.5);
	lo = max(min(f0),min(good)); hi=min(max(f0),max(good));
	set(gca, 'ylim', [lo-0.5; hi+0.5]);     
	%set(gca, 'xlim', [1,nframes]/fsr);
% 	set(get(gca,'ylabel'), 'string', 'Oct. re: 440 Hz');
% 	set(get(gca,'xlabel'), 'string', 's');
%---------------------------------------------------------------------------
% title('(b). F_0 Contour using Autocorrelation', 'FontName', 'Times New Roman', 'FontSize', 12);
% xlim([2.275 2.997]);
% ylim([0 700]);
% xlabel('Time (s)', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('F_0 (Hz)', 'FontName', 'Times New Roman', 'FontSize', 12);
ylim([0 1000])
set(gca, 'XTickLabelMode', 'Manual')
set(gca, 'XTick', [])
y2t = get(gca, 'YTick');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12)
xlim([1/fs length(x)/fs]);
l2 = legend('\bf(b) F_0 contour using Autocorrelation function', 'Location', 'northoutside');
legend('boxoff')
l2.FontSize = 12;
% %--------------------------------------------------------------------------
% % CruUnit Mean
% ax(3) = subplot(4, 1, 3);
% plot(cTs, cryMeanf0, 'k.', 'MarkerSize', 10);hold on
% % title('(c). Mean F_0', 'FontName', 'Times New Roman', 'FontSize', 12);
% % xlim([2.275 2.997]);
% % ylim([0 1500]);
% set(gca, 'XTickLabelMode', 'Manual')
% set(gca, 'XTick', [])
% set(gca, 'ylim', [0; max(cryMeanf0)+100]);  
% % xlabel('Time (s)', 'FontName', 'Times New Roman', 'FontSize', 12);
% ylabel('F_0 (Hz)', 'FontName', 'Times New Roman', 'FontSize', 12);
% xlim([1/fs length(x)/fs]);
% %--------------------------------------------------------------------------

% %--------------------------------------------------------------------------
% % CruUnit Deviation
% ax(4) = subplot(6, 1, 4);
% errorbar(cTs, (cryMeanf0-mean(cryMeanf0)), err, '.k', 'MarkerSize', 10); hold on
% % title('(d). Cry Deviation', 'FontName', 'Times New Roman', 'FontSize', 12);
% % xlim([2.275 2.997]);
% ylim([-(max(cryMeanf0)+max(cryDevf0)) max(cryMeanf0)+max(cryDevf0)]);
% % set(gca, 'ylim', [0; max(cryMeanf0)+max(cryDevf0)+50]);  
% % xlabel('Time (s)', 'FontName', 'Times New Roman', 'FontSize', 12);
% % ylabel('F_0 (Hz)', 'FontName', 'Times New Roman', 'FontSize', 12);
% xlim([1/fs length(x)/fs]);
% set(gca, 'XTickLabelMode', 'Manual')
% set(gca, 'XTick', [])
% %--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% CruUnit SSE
ax(5) = subplot(4, 1, 3);
h = stem(cTs, SSE_42, 'k', 'filled');
hold on;
y1=median(SSE_42);
plot([1:length(x)]./fs, y1*ones(size([1:length(x)]./fs)))
% h(1).Marker = 'none';
h(1).LineWidth = 1.5;
h(1).MarkerSize = 3;
hold on
% title('(d). Cry Deviation', 'FontName', 'Times New Roman', 'FontSize', 12);
% xlim([2.275 2.997]);
% ylim([0 1500]);
set(gca, 'ylim', [0; median(SSE_42)+10]);  
xlabel('Time (s)', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('SSE Ratio', 'FontName', 'Times New Roman', 'FontSize', 12);
y2t = get(gca, 'YTick');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12)
xlim([1/fs length(x)/fs]);
l3 = legend('\bf(c) Sub-band spectral energy ratio of 4^{th} to 2^{nd} Sub-band', 'Location', 'northoutside');
legend('boxoff')
l3.FontSize = 12;
% set(gca, 'XTickLabelMode', 'Manual')
% set(gca, 'XTick', [])
%--------------------------------------------------------------------------
linkaxes(ax, 'x');
%--------------------------------------------------------------------------
% dMFCCd
bx(6) = subplot(4, 1, 4);
b = stem(linspace(1, 13, 13), dMFCCd, 'k'); hold on;
% b(1).MarkerSize = 10;
b(1).LineWidth = 1.5;
y2=1.5;
plot(linspace(0, 14, 14),y2*ones(size(linspace(1, 14, 14))))
% title('(e). SSE', 'FontName', 'Times New Roman', 'FontSize', 12);
% xlim([2.275 2.997]);
ylim([0 max(dMFCCd)+0.2]);
xlabel('Coefficient No.', 'FontName', 'Times New Roman', 'FontSize', 12);
ylabel('\DeltaMFCCdev', 'FontName', 'Times New Roman', 'FontSize', 12);
y2t = get(gca, 'YTick');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12)
l4 = legend('\bf(d) \Delta MFCC deviation', 'Location', 'northoutside');
legend('boxoff')
l4.FontSize = 12;
%--------------------------------------------------------------------------

