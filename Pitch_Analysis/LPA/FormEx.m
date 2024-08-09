[x, fs] = audioread('S38_F_18m_sn1_c01_01_Pain.wav');
x = x(:, 1);%Taking out the excerpts

segmentlen = 100;
noverlap = 90;
NFFT = 128;

spectrogram(x,segmentlen,noverlap,NFFT,fs,'yaxis')
title('Signal Spectrogram')