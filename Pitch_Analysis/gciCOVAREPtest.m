
clear all;

% Settings
F0min = 150; % Minimum F0 set to 80 Hz
F0max = 1500; % Maximum F0 set to 80 Hz
frame_shift = 3; % Frame shift in ms

% Load soundfile
[x,fs] = audioread('S13_F_01m_sn1_c01_19_Pain.wav');
x = x(:, 1);%Taking out the excerpts
% Extract the pitch and voicing information
[srh_f0,srh_vuv,srh_vuvc,srh_time] = pitch_srh(x,fs,F0min,F0max,frame_shift);
% GCI estimation
sd_gci = gci_sedreams(x,fs,median(srh_f0),1);        % SEDREAMS
% Plots
t=(0:length(x)-1)/fs;



zgci = ones(1, length(p1));
mzgci = ones(1, length(pmod1));
p1 =p1';
pmod1 = pmod1';

%% Figures
figure;
ax(1) = subplot(7, 1, 1);
% --------------------------------------------------------------------------
plot([1:length(x)]./fs, x./max(x), 'k');
ylim([-1.5 1.5]);
title('Fig. a: Input Cry Signal, Fs = 48 KHz', 'FontName', 'SansSerif');
xlim([1/fs length(x)/fs]);
% xlim([12 21.4]);
xlabel('Time (s)', 'FontName', 'SansSerif');
ax(2) = subplot(7, 1, 2);
plot(xaxis3z, f03V, 'k.'); %'LineWidth',1.5);
xlim([1/fs length(x)/fs]);
xlabel('Time (s)', 'FontName', 'SansSerif');
ylabel('F_0 (Hz)', 'FontName', 'SansSerif');
title('Fig. c: F_0 Contour using ZFF', 'FontName', 'SansSerif');
ylim([0 1750]);
ax(3) = subplot(7, 1, 3);
plot([1:length(y)]./fs, y, 'k'); %'LineWidth',1.5);
hold on
stem(p1, zgci, 'r', 'Marker', '^'); 
xlim([1/fs length(x)/fs]);
xlabel('Time (s)', 'FontName', 'SansSerif');
title('Fig. c: ZFF output with GCIs', 'FontName', 'SansSerif');
ylim([-1.3 1.3]);
ax(4) = subplot(7, 1, 4);
plot(xaxis3mz, f03mV, 'k.'); %'LineWidth',1.5);
xlim([1/fs length(x)/fs]);
xlabel('Time (s)', 'FontName', 'SansSerif');
ylabel('F_0 (Hz)', 'FontName', 'SansSerif');
title('Fig. c: F_0 Contour using modZFF', 'FontName', 'SansSerif');
ylim([0 1750]);
ax(5) = subplot(7, 1, 5);
plot([1:length(ymod)]./fs, ymod, 'k'); %'LineWidth',1.5);
hold on
stem(pmod1, mzgci, 'r', 'Marker', '^'); 
xlim([1/fs length(x)/fs]);
xlabel('Time (s)', 'FontName', 'SansSerif');
title('Fig. c: modZFF output with GCIs', 'FontName', 'SansSerif');
ylim([-1.3 1.3]);
xlim([1/fs length(x)/fs]);
% linkaxes(ax, 'x');
ax(6) = subplot(7, 1, 6);
% figure
plot(t,x, 'b');
hold on
plot(srh_time, srh_vuv, 'g');
stem(sd_gci,ones(1,length(sd_gci)),'r', 'Marker', '^');
%     stem(se_gci,ones(1,length(se_gci))*-.1,'r');
legend('Speech signal','Voicing (SRH)', 'GCI (SEDREAMS)','GCI (SE-VQ)');
xlabel('Time [s]');
ylabel('Amplitude');
ylim([-1.3 1.3]);
ax(7) = subplot(7, 1, 7);
plot(srh_time, srh_f0, '.k');
legend('f0 (SRH)');
xlabel('Time [s]');
ylabel('Hz');
   
linkaxes(ax, 'x');