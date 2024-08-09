% --------------------------------------------------------------------------
% --------------------------------------------------------------------------
% Reading an excel file of features and get the basic statistics by performing VAD on it
% --------------------------------------------------------------------------
% Following parameters are calculated:
% 1. cryMeanSSE
% 2. cryDevSSE
% 3. caseMeanSSE
% 4. caseDevSSE 
% 5. cryTotMeanSSE
% 6. cryAvgDevSSE
% --------------------------------------------------------------------------
% Instructions towards getting data for Sub-band Spectral Energy Data
% 1. Save the feature array from Python script in a 6Xn populated .xlsx
% file where 6: # of Filters and n are the Fram #s
% 2. Naming Conv: SSE6_S05_F_36m_sn1_c02_07__Envr (An excel file)
% 3. Save such files for each category and perform Stats using this script
% Category-wise and store above 6 parameter values for all the cases in an
% excel separately and then finally derive the summaries that make sense
% --------------------------------------------------------------------------
% Author: Shivam Sharma (SS)
% Place: IIIT Chittoor; 11 Sept, 2017
% Updates: 
% Update 1: 11 Sept, '17: Wrote the code for SSE masking and Statistical summary
% Update 2: 13 Sept, '17: Added the code for MFCC and dMFCC masking (Outputs: melFeatUp, dmelFeatUp: To be added once the Feature-set length ambiguity is resolved)
% --------------------------------------------------------------------------
% --------------------------------------------------------------------------
function [cryMeanSSE, cryDevSSE, caseMedSSE, caseMedDevSSE, cryTotMeanSSE, cryAvgDevSSE, sseFeatUp, begP, endP] = featStats_Med(cryFile, featFile)
% close all; clc; clear all;
% Voice_Sample_Exp4_183 ms

% Feature Data Excel Files Path
xlSSEFeatPath = 'D:\Shivam\Research_IIITS\Experiments\Data\Cry Feature Data\Raw_Features_SrcPython\SSE\Environmental Factors\';
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
sseFeatin = xlsread(strcat(xlSSEFeatPath, featName));
sseFeatinInv = sseFeatin';
sseFeat = (nan(size(sseFeatin)))';

numInd = find(vs(1:length(sseFeat),3));
sseFeat(numInd, :) = sseFeatinInv(numInd, :);
sseFeatUp = sseFeat';
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
diffVar = diff([0; vs(1:length(sseFeat), 3); 0]);
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
        cryMeanSSE(filt, i) = mean(sseFeatUp(filt, begP(i):endP(i)));
        cryDevSSE(filt, i) = std(sseFeatUp(filt, begP(i):endP(i)));
    end
end

% Calculate the Avg - Avg and Std of Filterbank Energies for the entire
% SESSION (Vector)
caseMedSSE = median(cryMeanSSE, 2);
caseMedDevSSE = median(cryDevSSE, 2);

% Calculate the Total Avg Energy and Average Std of the Filterbank Energies
% for each CRY (Scalar)
cryTotMeanSSE = sum(cryMeanSSE, 1);
cryAvgDevSSE = mean(cryDevSSE, 1);
end
% --------------------------------------------------------------------------







