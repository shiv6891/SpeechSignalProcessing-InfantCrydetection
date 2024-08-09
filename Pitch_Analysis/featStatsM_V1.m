% --------------------------------------------------------------------------
% --------------------------------------------------------------------------
% Reading an excel file of features and get the basic statistics by performing VAD on it
% --------------------------------------------------------------------------
% Following parameters are calculated:
% 1. caseMeanM
% 2. caseDevM
% --------------------------------------------------------------------------
% Instructions towards getting data for MFCC
% 1. Save the feature array from Python script in a 13Xn populated .xlsx
% file where 13: # of Coefficients and n are the Frame #s
% 2. Naming Conv: M6_S05_F_36m_sn1_c02_07__Envr (An excel file)
% 3. Save such files for each category and perform Stats using this script
% Category-wise and store above 13 parameter values for all the cases in an
% excel separately and then finally derive the summaries that make sense
% --------------------------------------------------------------------------
% Instructions towards getting data for MFCC
% 1. Save the feature array from Python script in a 13Xn populated .xlsx
% file where 13: # of Coefficients and n are the Frame #s
% 2. Naming Conv: M6_S05_F_36m_sn1_c02_07__Envr (An excel file)
% 3. Save such files for each category and perform Stats using this script
% Category-wise and store above 13 parameter values for all the cases in an
% excel separately and then finally derive the summaries that make sense
% --------------------------------------------------------------------------
% Author: Shivam Sharma (SS)
% Place: IIIT Chittoor; 08 Nov, 2017
% Updates: 
% Update 1: 11 Sept, '17    : Wrote the code for M masking and Statistical summary
% Update 2: 13 Sept, '17    : Added the code for MFCC and dMFCC masking (Outputs: melFeatUp, dmelFeatUp: To be added once the Feature-set length ambiguity is resolved)
% Update 3: 08 Nov, '17     : Updated for MFCC
% --------------------------------------------------------------------------
% --------------------------------------------------------------------------
function [cryMeanM, cryDevM, caseMeanM, caseMeanDevM, melFeatUp, cryMeandM,	cryDevdM, caseMeandM, caseMeanDevdM, dmelFeatUp, begP, endP] = featStatsM_V1(cryFile, featFile)
% close all; clc; clear all;
% Voice_Sample_Exp4_183 ms

% Feature Data Excel Files Path
% xlMFeatPath = 'D:\Shivam\Research_IIITS\Experiments\Data\Cry Feature Data\Raw_Features_SrcPython\M\Environmental Factors\';
xlMFCCFeatPath = 'D:\Shivam\Research_IIITS\Experiments\Data\Cry Feature Data\Raw_Features_SrcPython\Data_V4\MFCC\Environmental Factors\MFCC_';
xldMFCCFeatPath = 'D:\Shivam\Research_IIITS\Experiments\Data\Cry Feature Data\Raw_Features_SrcPython\Data_V4\dMFCC\Environmental Factors\dMFCC_';
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
% Read the file and mask the features with VAD (Do this for M, MFCC and dMFCC Features)
% 1. M
% MFeatin = xlsread(strcat(xlMFeatPath, featName));
% MFeatinInv = MFeatin';
% MFeat = (nan(size(MFeatin)))';
% 
% numInd = find(vs(1:length(MFeat),3));
% MFeat(numInd, :) = MFeatinInv(numInd, :);
% MFeatUp = MFeat';
% --------------------------------------------------------------------------
% 2. MFCC
melFeatin = xlsread(strcat(xlMFCCFeatPath, featName));
melFeatinInv = melFeatin';
melFeat = (nan(size(melFeatin, 1), size(melFeatin, 2)-2))';
mnumInd = find(vs(1:length(melFeat),3));
melFeat(mnumInd, :) = melFeatinInv(mnumInd, :);
melFeatUp = melFeat';       % 13Xn
% --------------------------------------------------------------------------
% 3. dMFCC
dmelFeatin = xlsread(strcat(xldMFCCFeatPath, featName));
dmelFeatinInv = dmelFeatin';
dmelFeat = (nan(size(dmelFeatin, 1), size(dmelFeatin, 2)-2))';
dnumInd = find(vs(1:length(dmelFeat),3));
dmelFeat(dnumInd, :) = dmelFeatinInv(dnumInd, :);
dmelFeatUp = dmelFeat';
% --------------------------------------------------------------------------
%% Average and Standard Deviation of the MFCC's for each case/cry
% Get the start and end indices of the VAD regions
diffVar = diff([0; vs(1:length(melFeat), 3); 0]);
% Beginning and Ending Indices of the cries
begP = find(diffVar==1);
endP = find(diffVar==-1);
endP = endP-1;

% Calculate Avg and Std for all the "Mel Coeffs" (1-13 here) for all the cries
cLen = length(begP);
cryMeanM = zeros(13, cLen);                                                %   Fundamental Parameter
cryDevM = zeros(13, cLen);
for coeff = 1:13
    for i = 1:cLen
        cryMeanM(coeff, i) = mean(melFeatUp(coeff, begP(i):endP(i)));
        cryDevM(coeff, i) = std(melFeatUp(coeff, begP(i):endP(i)));
    end
end

% Calculate the Avg - Avg and Std of MFCC for entire session/case
% SESSION (Vector)
caseMeanM = (mean(cryMeanM, 2))';       %***An important MFCC parameter***
caseMeanDevM = (mean(cryDevM, 2))';
% -------------------------------------------------------------------------
% Calculate Avg and Std for all the "delta-Mel Coeffs" (1-13 here) and all the cries

cryMeandM = zeros(13, cLen);                                                %   Fundamental Parameter
cryDevdM = zeros(13, cLen);
for coeff = 1:13
    for i = 1:cLen
        cryMeandM(coeff, i) = mean(dmelFeatUp(coeff, begP(i):endP(i)));
        cryDevdM(coeff, i) = std(dmelFeatUp(coeff, begP(i):endP(i)));
    end
end

% Calculate the Avg - Avg and Std of del MFCC for entire session/case
% SESSION (Vector)
caseMeandM = (mean(cryMeandM, 2))';       %***An important MFCC parameter***
caseMeanDevdM = (mean(cryDevdM, 2))';


end
% --------------------------------------------------------------------------







