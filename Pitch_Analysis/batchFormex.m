% Get the Form stat summary batchwise
% read all the wav files  from each category
close all; clearvars; clc;
list = ls('D:\Shivam\IIITS_ICSD2_2016 Collection_V4_OK_RePreProcSeq\Cat_Data\Environmental Factors\*.wav');
n = size(list, 1);

for i = 1:n
    display(strcat(strcat(strcat('Processing File Number:', num2str(i)), ', Name:'), list(i,:)));
%     wavlist(i, :) = strrep(list(i, :),'xlsx','wav');
    
    [cryUMeanform, cryUDevform, caseMeanform, caseFormDiff, caseDevform, NDevform, form, t, begP, endP] = FormantStats(list(i, :));
    cryInd = [begP, endP];
%     F0 summaries
    cd 'D:\Shivam\Research_IIITS\Experiments\Data\Cry Feature Data\JSON\b_Form_Summary_Json_Mean\Environmental Factors\'    
%     json1=savejson('',cryUMeanform,strcat(strrep(list(i, :),'.wav',''), '_cryUMeanform.jason'));
%     json2=savejson('',cryUDevform,strcat(strrep(list(i, :),'.wav',''), '_cryUDevform.jason'));
    json3=savejson('',caseMeanform,strcat(strrep(list(i, :),'.wav',''), '_caseMeanform.jason'));
    json4=savejson('',caseFormDiff,strcat(strrep(list(i, :),'.wav',''), '_caseformDiff.jason'));
%     json5=savejson('',caseDevform,strcat(strrep(list(i, :),'.wav',''), '_caseDevform.jason'));
%     json6=savejson('',NDevform,strcat(strrep(list(i, :),'.wav',''), '_NDevform.jason'));
%     json7=savejson('',form,strcat(strrep(list(i, :),'.wav',''), '_form.jason'));
%     json8=savejson('',t,strcat(strrep(list(i, :),'.wav',''), '_t.jason'));    
end


