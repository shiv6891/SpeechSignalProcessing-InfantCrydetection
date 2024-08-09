%% GCI plots
% Plots the F0 and GCIs 
zgci = ones(1, length(p1));
mzgci = ones(1, length(pmod1));
p1 =p1';
pmod1 = pmod1';
%% plots
figure;
ax(1) = subplot(5, 1, 1);
% --------------------------------------------------------------------------
plot([1:length(x)]./fs, x./max(x), 'k');
ylim([-1.5 1.5]);
title('Fig. a: Input Cry Signal, Fs = 48 KHz', 'FontName', 'SansSerif');
xlim([1/fs length(x)/fs]);
% xlim([12 21.4]);
xlabel('Time (s)', 'FontName', 'SansSerif');
ax(2) = subplot(5, 1, 2);
plot(xaxis3, f03V, 'k.'); %'LineWidth',1.5);
xlim([1/fs length(x)/fs]);
xlabel('Time (s)', 'FontName', 'SansSerif');
ylabel('F_0 (Hz)', 'FontName', 'SansSerif');
title('Fig. c: F_0 Contour using ZFF', 'FontName', 'SansSerif');
ylim([0 1750]);
ax(3) = subplot(5, 1, 3);
plot([1:length(y)]./fs, y, 'k'); %'LineWidth',1.5);
hold on
stem(p1, zgci, 'r', 'Marker', '^'); 
xlim([1/fs length(x)/fs]);
xlabel('Time (s)', 'FontName', 'SansSerif');
title('Fig. c: ZFF output with GCIs', 'FontName', 'SansSerif');
ylim([-1.3 1.3]);
ax(4) = subplot(5, 1, 4);
plot(mxaxis3, mf03V, 'k.'); %'LineWidth',1.5);
xlim([1/fs length(x)/fs]);
xlabel('Time (s)', 'FontName', 'SansSerif');
ylabel('F_0 (Hz)', 'FontName', 'SansSerif');
title('Fig. c: F_0 Contour using modZFF', 'FontName', 'SansSerif');
ylim([0 1750]);
ax(5) = subplot(5, 1, 5);
plot([1:length(ymod)]./fs, ymod, 'k'); %'LineWidth',1.5);
hold on
stem(pmod1, mzgci, 'r', 'Marker', '^'); 
xlim([1/fs length(x)/fs]);
xlabel('Time (s)', 'FontName', 'SansSerif');
title('Fig. c: modZFF output with GCIs', 'FontName', 'SansSerif');
ylim([-1.3 1.3]);
xlim([1/fs length(x)/fs]);
linkaxes(ax, 'x');