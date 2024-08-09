% fs1 = (length(f03V)/length(x))/fs
f03V2 = f03V;
% FS1 = ceil(length(f03V)/(length(x)/fs));
% FS2 = ceil(length(mf03V)/(length(x)/fs));
formatSpec = '%f %f %d';
sizeA = [3 Inf];
% Read the content of the label file
fileID = fopen('S13_F_01m_sn1_c01_19_Pain.txt','r');
A = fscanf(fileID,formatSpec, sizeA);
A = A';
fclose(fileID);
size(A)
% f03V
% mf03V
% xaxis3
% mxaxis3
% Re-estimating the new estimates using the manually annotated Hyper-phonated regions
for i = 1:length(A)
    mzf0seg1 = mf03V(find(mxaxis3>A(i,1)&mxaxis3<A(i,2))); %First chunk of source estimates
    zf0Ind = find(xaxis3>A(i,1)&xaxis3<A(i,2));
    zf0seg1 = f03V(zf0Ind);                 % Locations where to put 'em
    f0seg1 = resample(mzf0seg1, size(zf0seg1,1), size(mzf0seg1, 1));
    f03V2(zf0Ind) = f0seg1;
    clear mzf0seg1 zf0Ind zf0seg1 f0seg1
end



% f0seg1 = resample(mf0seg1, FS1, FS2);



size(f0seg1)

