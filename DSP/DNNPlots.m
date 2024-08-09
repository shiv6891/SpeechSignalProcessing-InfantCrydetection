clear; close all
%data = importdata('/remote/idiap.svm/home.active/ssharma/Shivam/Workstation/Work/Experiments/Exp5_DNNCry/1FoldTraining/Sil_NoSil_RawZFF_Perf_V1.ods');
%data2 = importdata('/remote/idiap.svm/home.active/ssharma/Desktop/testsheet');
%fid = fopen('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/Exp5_DNNCry/5FoldTraining/NNETExp3a_2Layers_5Fold_5spochtrn/5FoldVal_Perf_All_only.csv');
%data3=fread(fid);

num = xlsread('/idiap/home/ssharma/Shivam/Workstation/Work/Experiments/Exp5_DNNCry/Results/ZFFCry_All_Sheet.xlsx');

% F1 scores for each config from 2 to 5 by considering the data per fold

f1ind_ZFF = zeros(5, 5);
for i = 0:4
    i1=5*i+i+1;
    f1ind_ZFF(:,i+1) = num(i1:i1+4, 6);    
end


f1ind_CRY = zeros(5, 5);
for i = 5:9
    i1=5*i+i+1;
    f1ind_CRY(:,i-4) = num(i1:i1+4, 6);    
end
g = [2,3,4,5,6];
%%
figure;
subplot(1,2,1); boxplot(f1ind_ZFF, g);
title('f-1 scores (ZFF input)')
xlabel('\# Conv Layers')
ylabel('f-1 score (in %)')
subplot(1,2,2); boxplot(f1ind_CRY, g);
title('f-1 scores (CRY input)')
xlabel('\# Conv Layers')
ylabel('f-1 score (in %)')
%%
y1 = median(f1ind_ZFF);
y2 = median(f1ind_CRY);
ynegZFF1 = median(f1ind_ZFF)-min(f1ind_ZFF);
yposZFF1 = max(f1ind_ZFF)-median(f1ind_ZFF);
ynegCRY1 = median(f1ind_CRY)-min(f1ind_CRY);
yposCRY1 = max(f1ind_CRY)-median(f1ind_CRY);
figure
errorbar(g,y1,ynegZFF1,yposZFF1, '-s','MarkerSize',10,...
    'MarkerEdgeColor','red','MarkerFaceColor','red');hold on;
errorbar(g,y2,ynegCRY1,yposCRY1, '-s','MarkerSize',10,...
    'MarkerEdgeColor','blue','MarkerFaceColor','blue')
xlim([1 7])
ylim([0.7 1.05])
xlabel('\# Conv Layers')
ylabel('f-1 score (in %)')
legend('Input: ZFF signal', 'Input: Cry signal')
%%

% f1Comp = [0.992	0.91	0.958;	0.756	0.744	0.758;	0.714	0.73 NaN];
f1Comp = [0.992	0.91	0.958;	0.756	0.744	0.758];
figure;
hB=bar(f1Comp); 
hAx=gca; 
legend('w/o filtering', '1 Pole', '3 Poles')
str={'ZFF'; 'Cry'};
hAx.XTickLabel=str;
set(gca, 'XTickLabel',str, 'XTick',1:numel(str))
title('Comparison of f-1 scores for training using different input sets')
% labels= {'1', '2', '3', '4', '5', '6'};
% labels = ['1', '2', '3', '4', '5', '6'];
% xt = get(gca, 'XTick');
% text(xt, f1Comp, labels)
% for i=1:length(hB)  % iterate over number of bar objects
%   hT=[hT,text(hB(i).XData+hB(i).XOffset,hB(i).YData,labels(:,i), ...
%           'VerticalAlignment','bottom','horizontalalign','center')];
% end
%%
% %% Line plot for comparin Average f-1 scores for different conv layers for Raw and ZFF
% 
% f1_all = zeros(10,1);
% for i = 1:10    
%     f1_all(i) = num(i*6, 7);    
% end
% 
% f1_all = [f1_all(1:5,1),f1_all(6:10,1)];
% 
% plot(f1_all);
