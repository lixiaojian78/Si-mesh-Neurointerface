

load data_20180121.mat

stimdata=all_stidata;
spondata=all_spndata;

%%

load 20171003_data;

stimdata=[stimdata sti_data'];
spondata=[spondata spon_data'];

%%

X=[spondata;stimdata]';
figure;
boxplot(X)
box off;
axis square;
set(gca,'TickDir','out')
xlabel('spon            stim')
ylabel('firing rate (spikes/s)')
title('p=3.8e-34 paired t-test n=371 from 3 mouses')
[h,p]=ttest(spondata,stimdata)



%%

rate_data=X;
filename='rate_data';
xlswrite(filename,rate_data');

















