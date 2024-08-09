% Extract the features from all the files of a folder
% *******************Please Note***********************
% Do not leave any source file to be used open while performing file operations
close all; clear all; clc;
% This file takes in the raw features storedin excel files and calculate the statical summaries out of them
% cd ''D:\Shivam\Research @ IIITS\Experiments\\Cry Feature Data\\SSE\Ailment\'
list = ls('D:\Shivam\IIITS_ICSD2_2016 Collection_V4_OK_RePreProcSeq\Cat_Data\Environmental Factors\*.wav');
% fileList = list(3:end,:);
n = size(list, 1);

for i = 1:n
    display(strcat(strcat(strcat('Processing File Number:', num2str(i)), ', Name:'), list(i,:)));
%     wavlist(i, :) = strrep(list(i, :),'xlsx','wav');
    xllist(i, :) = strrep(list(i, :),'wav', 'xlsx');
%     For SSE feature extraction
%     [cryUMeanSSE, cryUDevSSE, caseMedSSE, caseMedDevSSE, cryUTotMeanSSE, cryUAvgDevSSE, sseFeat, begP, endP] = featStatsM(list(i, :), xllist(i, :));
%     Parameters to be derived from Mel analysis
%     cryMeanM, cryDevM, caseMeanM, caseMeanDevM, melFeatUp, cryMeandM,	cryDevdM, caseMeandM, caseMeanDevdM, dmelFeatUp, begP, endP
    [cryMeanMel, cryDevMel, caseMeanMel, caseMeanDevMel, MFeatUp, cryMeandMel,	cryDevdMel, caseMeandMel, caseMeanDevdMel, dMFeatUp, begP, endP] = featStatsM_V1(list(i, :), xllist(i, :));
    cryInd = [begP, endP];
%     melFeat, dmelFeat,
      cd 'D:\Shivam\Research_IIITS\Experiments\Data\Cry Feature Data\JSON\MLFeat_V2\MFCCJson_V1\Environmental Factors\'
%     ----------------------------------------------------------------------------------------------------------------------
% %     ----------------------------------------------------------------------------------------------------------------------
% %     For "SSE" related feature data
%     json1=savejson('',cryUMeanSSE,strcat(strrep(list(i, :),'.xlsx',''), '_cryUMeanSSE.jason'));
%     json2=savejson('',cryUDevSSE,strcat(strrep(list(i, :),'.xlsx',''), '_cryUDevSSE.jason'));
%     json3=savejson('',caseMedSSE,strcat(strrep(list(i, :),'.xlsx',''), '_caseMeanSSE.jason'));
%     json4=savejson('',caseMedDevSSE,strcat(strrep(list(i, :),'.xlsx',''), '_caseDevSSE.jason'));
%     json5=savejson('',cryUTotMeanSSE,strcat(strrep(list(i, :),'.xlsx',''), '_cryUTotMeanSSE.jason'));
%     json6=savejson('',cryUAvgDevSSE,strcat(strrep(list(i, :),'.xlsx',''), '_cryUAvgDevSSE.jason'));
%     json7=savejson('',sseFeat,strcat(strrep(list(i, :),'.xlsx',''), '_sseFeat.jason'));
%     json8=savejson('',cryInd,strcat(strrep(list(i, :),'.xlsx',''), '_cryInd.jason'));
% %     ----------------------------------------------------------------------------------------------------------------------
%     ----------------------------------------------------------------------------------------------------------------------
%     For "MFCC and dMFCC" related feature data
    json1=savejson('',cryMeanMel,strcat(strrep(list(i, :),'.wav',''), '_cryUMeanM.jason'));
    json2=savejson('',cryDevMel,strcat(strrep(list(i, :),'.wav',''), '_cryUDevM.jason'));
    json3=savejson('',cryMeandMel,strcat(strrep(list(i, :),'.wav',''), '_cryUMeandM.jason'));
    json4=savejson('',cryDevdMel,strcat(strrep(list(i, :),'.wav',''), '_cryUDevdM.jason'));
    json5=savejson('',caseMeanMel, strcat(strrep(list(i, :),'.wav',''), '_caseMeanMelFeat.jason'));
    json6=savejson('',caseMeanDevMel, strcat(strrep(list(i, :),'.wav',''), '_caseMeanDevMelFeat.jason'));
    json7=savejson('',caseMeandMel, strcat(strrep(list(i, :),'.wav',''), '_caseMeandMelFeat.jason'));
    json8=savejson('',caseMeanDevdMel, strcat(strrep(list(i, :),'.wav',''), '_caseMeanDevdMelFeat.jason'));
    json9=savejson('',MFeatUp,strcat(strrep(list(i, :),'.wav',''), '_VADMel.jason'));    
    json10=savejson('',cryInd,strcat(strrep(list(i, :),'.wav',''), '_cryInd.jason'));
%     ----------------------------------------------------------------------------------------------------------------------
%     ----------------------------------------------------------------------------------------------------------------------
end


% Now export the Cry Summary data collected about the acoustic features,
% SSE in particular and, to excel sheets.

