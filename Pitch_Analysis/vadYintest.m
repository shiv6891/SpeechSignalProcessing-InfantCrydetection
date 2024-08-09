close all; clc;
clear all;
% Voice_Sample_Exp4_183 ms
% 11_EvrTre_Eng_M_Pop_CR
% 17_HatnOn_Eng_F_Pop_RI
% 22_RasRad_HiC_M_MadSar_Jas
[x, fs] = wavread('082. Laura_Its Not_ex.wav');
% [x, fs] = audioread('Flute_ARRhm_KhneKo.mp3');

x = x(:, 1);%Taking out the excerpts

% plotflag = 1;
% [vad, meant0]= vadAC(x,fs,plotflag);
% Voicebox
% [vs,zo]=vadsohn(x,fs, 't');
% [vs,zo, nv, nd, nr, ni, fs0, qq, nj, nw]=vadsohn(x,fs,'p');
% [nframes, fsr, f0, good, best, r] = 
figure;
yin(x,fs);