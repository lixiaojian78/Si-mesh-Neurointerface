


bdata={'20180128_leftM1','20180128_rightM1','20180131_alldata_mouse1','20180131_alldata_mouse2','20180204_alldata_mouse1', ...
       '20180125_all_data_left_M1','20180125_all_data_left_M2','20180125_all_data_right_M1','data_20171001_rightM1'};

num_data=length(bdata);

maxamp_bf=cell(1);
maxamp_af=cell(1);
all_amp_bf=[];
all_amp_af=[];
maxamp_bf_other=cell(1);
maxamp_af_other=cell(1);
all_amp_bf_other=[];
all_amp_af_other=[];
for idxd=1:num_data
    load(bdata{idxd},'max_bf','max_af','max_bf_other','max_af_other');
    maxamp_bf{idxd}=max_bf;
    maxamp_af{idxd}=max_af;
    
    maxamp_bf_other{idxd}=max_bf_other;
    maxamp_af_other{idxd}=max_af_other;
    
    all_amp_bf=[all_amp_bf maxamp_bf{idxd}];
    all_amp_af=[all_amp_af maxamp_af{idxd}];
    
    all_amp_bf_other=[all_amp_bf_other maxamp_bf_other{idxd}];
    all_amp_af_other=[all_amp_af_other maxamp_af_other{idxd}];
end

%%

figure;
scatter(all_amp_bf,all_amp_af)

%%

stim_leftM1=[1,5,6,7];
stim_rightM1=[2,3,4,8,9];

leftsti_ambf=[maxamp_bf{1} maxamp_bf{5} maxamp_bf{6} maxamp_bf{7}];
leftsti_amaf=[maxamp_af{1} maxamp_af{5} maxamp_af{6} maxamp_af{7}];

rightsti_ambf=[maxamp_bf{2} maxamp_bf{3} maxamp_bf{4} maxamp_bf{8} maxamp_bf{9}];
rightsti_amaf=[maxamp_af{2} maxamp_af{3} maxamp_af{4} maxamp_af{8} maxamp_af{9}];


leftsti_ambf_other=[maxamp_bf_other{1} maxamp_bf_other{5} maxamp_bf_other{6} maxamp_bf_other{7}];
leftsti_amaf_other=[maxamp_af_other{1} maxamp_af_other{5} maxamp_af_other{6} maxamp_af_other{7}];

rightsti_ambf_other=[maxamp_bf_other{2} maxamp_bf_other{3} maxamp_bf_other{4} maxamp_bf_other{8} maxamp_bf_other{9}];
rightsti_amaf_other=[maxamp_af_other{2} maxamp_af_other{3} maxamp_af_other{4} maxamp_af_other{8} maxamp_af_other{9}];

%%

X1=[leftsti_ambf;leftsti_amaf]';
figure;
boxplot(X1)
box off;
axis square;
set(gca,'TickDir','out')
ylabel('max amplitude (pixel)')
xlabel('amplitude before stimulation        amplitude after stimulation')
[h,p]=ttest(leftsti_ambf,leftsti_amaf)
title('simulation on left M1 (4 mouses n=50)  p=9.6e-15 paired t-test')


X2=[rightsti_ambf;rightsti_amaf]';
figure;
boxplot(X2)
box off;
axis square;
set(gca,'TickDir','out')
ylabel('max amplitude (pixel)')
xlabel('amplitude before stimulation        amplitude after stimulation')
[h,p]=ttest(rightsti_ambf,rightsti_amaf)
title('simulation on right M1 (5 mouses n=119)  p=9.5e-26 paired t-test')

%%

X1_other=[leftsti_amaf_other;leftsti_amaf]';
figure;
boxplot(X1_other)
box off;
axis square;
set(gca,'TickDir','out')
ylabel('max amplitude (pixel)')
xlabel('amplitude left hand        amplitude right hand')
[h,p]=ttest(leftsti_amaf_other,leftsti_amaf)
title('simulation on left M1 (4 mouses n=50) p=9.9e-11 paired t-test')


X2_other=[rightsti_amaf_other;rightsti_amaf]';
figure;
boxplot(X2_other)
box off;
axis square;
set(gca,'TickDir','out')
ylabel('max amplitude (pixel)')
xlabel('amplitude right hand        amplitude left hand')
[h,p]=ttest(rightsti_amaf_other,rightsti_amaf)
title('simulation on right M1 (5 mouses n=119) p=1.0e-22 paried t-test')

%%

alldata.leftsti_ambf=leftsti_ambf;
alldata.leftsti_amaf=leftsti_amaf;
alldata.rightsti_ambf=rightsti_ambf;
alldata.rightsti_amaf=rightsti_amaf;

mov_data_stim_left_M1(:,1)=leftsti_ambf;
mov_data_stim_left_M1(:,2)=leftsti_amaf;
mov_data_stim_left_M1(:,3)=leftsti_ambf_other;
mov_data_stim_left_M1(:,4)=leftsti_amaf_other;

mov_data_stim_right_M1(:,1)=rightsti_ambf;
mov_data_stim_right_M1(:,2)=rightsti_amaf;
mov_data_stim_right_M1(:,3)=rightsti_ambf_other;
mov_data_stim_right_M1(:,4)=rightsti_amaf_other;


filename='mov_data_stim_left_M1';
xlswrite(filename,mov_data_stim_left_M1);
filename='mov_data_stim_right_M1';
xlswrite(filename,mov_data_stim_right_M1);


























