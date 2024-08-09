% --------------------------------------------------------------------------
% --------------------------------------------------------------------------
% Reading an excel file of features and get the basic statistics by performing VAD on it
% --------------------------------------------------------------------------
% Following parameters are calculated:
% 1. cryMeanM
% 2. cryDevM
% --------------------------------------------------------------------------
% Instructions towards getting data for MFCC
% 1. Save the feature array from Python script in a 13Xn populated .xlsx
% file where 13: # of Coefficients and n are the Frame #s
% 2. Naming Conv: SSE6_S05_F_36m_sn1_c02_07__Envr (An excel file)
% 3. Save such files for each category and perform Stats using this script
% Category-wise and store above 13 parameter values for all the cases in an
% excel separately and then finally derive the summaries that make sense
% --------------------------------------------------------------------------
% Author: Shivam Sharma (SS)
% Place: IIIT Chittoor; 08 Nov, 2017
% Updates: 
% Update 1: 11 Sept, '17    : Wrote the code for SSE masking and Statistical summary
% Update 2: 13 Sept, '17    : Added the code for MFCC and dMFCC masking (Outputs: melFeatUp, dmelFeatUp: To be added once the Feature-set length ambiguity is resolved)
% Update 3: 08 Nov, '17     : Updated for MFCC
% --------------------------------------------------------------------------
% --------------------------------------------------------------------------
function [cryMeanSSE, cryDevSSE, caseMeanSSE, caseDevSSE, cryTotMeanSSE, cryAvgDevSSE, MFeatUp, begP, endP] = featStatsM(cryFile, featFile)
% close all; clc; clear all;
% Voice_Sample_Exp4_183 ms

% Feature Data Excel Files Path
xlSSEFeatPath = 'D:\Shivam\Research_IIITS\Experiments\Data\Cry Feature Data\Raw_Features_SrcPython\Data_V1\MFCC\Pain\';
% xlMFCCFeatPath = 'D:\Shivam\Research @ IIITS\Experiments\Cry Feature Data\MFCC\Ailment\MFCC_';
% xldMFCCFeatPath = 'D:\Shivam\Research @ IIITS\Experiments\Cry Feature Data\dMFCC\Ailment\dMFCC_';
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

%% Get the masked Features
% Read the file and mask the features with VAD (Do this for SSE, MFCC and dMFCC Features)
% 1. SSE
MFeatin = xlsread(strcat(xlSSEFeatPath, featName));
MFeatinInv = MFeatin';
MFeat = (nan(size(MFeatin)))';

numInd = find(vs(1:length(MFeat),3));
MFeat(numInd, :) = MFeatinInv(numInd, :);
MFeatUp = MFeat';           %   13Xn
% % --------------------------------------------------------------------------
% % 2. MFCC
% melFeatin = xlsread(strcat(xlMFCCFeatPath, featName));
% melFeatinInv = melFeatin';
% melFeat = (nan(size(melFeatin)))';
% 
% mnumInd = find(vs(1:length(melFeat),3));
% melFeat(mnumInd, :) = melFeatinInv(mnumInd, :);
% melFeatUp = melFeat';
% % --------------------------------------------------------------------------
% % 3. dMFCC
% dmelFeatin = xlsread(strcat(xldMFCCFeatPath, featName));
% dmelFeatinInv = dmelFeatin';
% dmelFeat = (nan(size(dmelFeatin)))';
% 
% dnumInd = find(vs(1:length(dmelFeat),3));
% dmelFeat(dnumInd, :) = dmelFeatinInv(dnumInd, :);
% dmelFeatUp = dmelFeat';
% % --------------------------------------------------------------------------
%% Average and Standard Deviation of the SSE's for each cry
% Get the start and end indices of the VAD regions
diffVar = diff([0; vs(1:length(MFeat), 3); 0]);
% Beginning and Ending Indices of the cries
begP = find(diffVar==1);
endP = find(diffVar==-1);
endP = endP-1;

% Calculate Avg and Std for all the filters (1-6 here) and all the cries
cLen = length(begP);
cryMeanSSE = zeros(6, cLen);                                                %   Fundamental Parameter
cryDevSSE = zeros(6, cLen);
for filt = 1:6
    for i = 1:cLen
        cryMeanSSE(filt, i) = mean(MFeatUp(filt, begP(i):endP(i)));
        cryDevSSE(filt, i) = std(MFeatUp(filt, begP(i):endP(i)));
    end
end

% Calculate the Avg - Avg and Std of Filterbank Energies for the entire
% SESSION
caseMeanSSE = mean(cryMeanSSE, 2);
caseDevSSE = mean(cryDevSSE, 2);

% Calculate the Total Avg Energy and Average Std of the Filterbank Energies for each CRY
cryTotMeanSSE = sum(cryMeanSSE, 1);
cryAvgDevSSE = mean(cryDevSSE, 1);
end
% --------------------------------------------------------------------------







