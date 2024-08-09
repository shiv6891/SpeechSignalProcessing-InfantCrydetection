%% Plots
figure;
ax(1) = subplot(4, 1, 1);
% --------------------------------------------------------------------------
% Plot Set 1
plot([1:length(x)]./fs, x./max(x), 'k');
hold on;
plot(xaxis0, vas, 'r',  'LineWidth',1.5); % plot from Voice Box: M Brooks
hold on;
plot(inXaxis, hMark, 'g',  'LineWidth',1.5); % Manually identified Hyper-phon regions
ylim([-1.5 1.5]);
title('Fig. a: Input Cry Signal, Fs = 48 KHz', 'FontName', 'SansSerif');
xlim([1/fs length(x)/fs]);
% xlim([12 21.4]);
xlabel('Time (s)', 'FontName', 'SansSerif');
%%ZFF Pitch conntour plots
ax(2) = subplot(4, 1, 2);
plot(xaxis3, f03V, 'k.'); %'LineWidth',1.5);
xlim([1/fs length(x)/fs]);
xlabel('Time (s)', 'FontName', 'SansSerif');
ylabel('F_0 (Hz)', 'FontName', 'SansSerif');
title('Fig. c: F_0 Contour using ZFF', 'FontName', 'SansSerif');
ylim([0 1750]);
ax(3) = subplot(4, 1, 3);
plot(mxaxis3, mf03V, 'k.'); %'LineWidth',1.5);
xlim([1/fs length(x)/fs]);
xlabel('Time (s)', 'FontName', 'SansSerif');
ylabel('F_0 (Hz)', 'FontName', 'SansSerif');
title('Fig. c: F_0 Contour using modZFF', 'FontName', 'SansSerif');
ylim([0 1750]);
ax(4) = subplot(4, 1, 4);
plot(xaxis3, f03V2, 'k.'); %'LineWidth',1.5);
xlim([1/fs length(x)/fs]);
xlabel('Time (s)', 'FontName', 'SansSerif');
ylabel('F_0 (Hz)', 'FontName', 'SansSerif');
title('Fig. c: Resetimated F_0 Contour', 'FontName', 'SansSerif');
ylim([0 1750]);

%%Link the axes finally
xlim([1/fs length(x)/fs]);
linkaxes(ax, 'x');