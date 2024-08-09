% This file returns the VAD masked Mel Features for the Cry Feature data

function [melFeatUp] = melVAD(cryFile, featFile)
% close all; clc; clear all;
% Voice_Sample_Exp4_183 ms

% Feature Data Excel Files Path
xlMFCCFeatPath = 'D:\Shivam\Research @ IIITS\Experiments\Cry Feature Data\MFCC\Ailment';

fileName = strtrim(cryFile);
featName = strtrim(featFile);
[x, fs] = wavread(fileName);
% [x, fs] = audioread('S21_F_28m_sn1_c01_13_Anxt.wav');
% For MP3 versions

%Transform into Monochannel
x = x(:, 1);

% Get the VAD details
[vs,zo]=vadsohn(x,fs, 't');
% xaxis0 = vs(:, 2);
% vas= vs(:, 3);
% vas = vas';

% Read the file and mask the features with VAD (Do this for SSE, MFCC and dMFCC Features)
melFeatin = xlsread(strcat(xlMFCCFeatPath, featName));
melFeatinInv = melFeatin';
melFeat = (nan(size(melFeatin)))';

numInd = find(vs(1:length(melFeat),3));
melFeat(numInd, :) = melFeatinInv(numInd, :);
melFeatUp = melFeat';
end