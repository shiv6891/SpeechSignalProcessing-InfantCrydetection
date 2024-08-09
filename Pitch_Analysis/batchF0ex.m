% Get the F0 stat summary batchwise
% read all the wav files  from each category
close all; clear all; clc;
list = ls('D:\Shivam\IIITS_ICSD2_2016 Collection_V4_OK_RePreProcSeq\Cat_Data\Environmental Factors\*.wav');
n = size(list, 1);

for i = 1:n
    display(strcat(strcat(strcat('Processing File Number:', num2str(i)), ', Name:'), list(i,:)));
%     wavlist(i, :) = strrep(list(i, :),'xlsx','wav');
    
    [cryUMeanf0, cryUDevf0, caseMeanf0, caseDevf0, NDevf0, f0, t, begP, endP] = F0Stats_Med(list(i, :));
    cryInd = [begP, endP];
%     F0 summaries
    cd 'D:\Shivam\Research_IIITS\Experiments\Data\Cry Feature Data\JSON\2_F0_Summary_Json_Median\Environmental Factors\'    
    json1=savejson('',cryUMeanf0,strcat(strrep(list(i, :),'.wav',''), '_cryUMeanf0.jason'));
    json2=savejson('',cryUDevf0,strcat(strrep(list(i, :),'.wav',''), '_cryUDevf0.jason'));
    json3=savejson('',caseMeanf0,strcat(strrep(list(i, :),'.wav',''), '_caseMeanf0.jason'));
    json4=savejson('',caseDevf0,strcat(strrep(list(i, :),'.wav',''), '_caseDevf0.jason'));
    json5=savejson('',NDevf0,strcat(strrep(list(i, :),'.wav',''), '_NDevf0.jason'));
    json6=savejson('',f0,strcat(strrep(list(i, :),'.wav',''), '_f0.jason'));
    json7=savejson('',t,strcat(strrep(list(i, :),'.wav',''), '_t.jason'));
    json8=savejson('',cryInd,strcat(strrep(list(i, :),'.wav',''), '_cryInd.jason'));
end


