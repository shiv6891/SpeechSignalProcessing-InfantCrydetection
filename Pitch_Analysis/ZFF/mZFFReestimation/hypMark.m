hMark = zeros(length([1:length(x)]./fs), 1);
inXaxis = [1:length(x)]./fs;
% hypInd = zeros(length(A), );
for i = 1:length(A)
    hMark(inXaxis>=A(i,1)&inXaxis<=A(i,2))=1;    
end

