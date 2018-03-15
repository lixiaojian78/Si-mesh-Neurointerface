

trial_num=15;

stim_length=[10,10,10,10,10,50,50,50,50,50,100,100,100,100,100];
stim_strenth=[20,40,60,80,100,20,40,60,80,100,20,40,60,80,100];


cri_spk=5;
tt=0:1/30:500;


%%


load(['Sti_15_t.mat'])
%%

use_chan=11;
use_trial=5;

figure;plot(tt,StiTrlTrace(:,use_chan,use_trial),'k')
tpdata=StiTrlTrace(:,use_chan,use_trial);
hold on;
plot(tt,(mean(tpdata(1:2000))-cri_spk*std(tpdata(1:2000))).*ones(1,length(tt)),'r','LineWidth',2)
% axis square;
box off;
set(gca,'TickDir','out','FontSize',30)
xlabel('time (ms)','FontSize',30)
ylabel('voltage (uv)','FontSize',30)
axis([0 500 -80 80])



%%



p_snip=cell(1,trial_num);
p_wave=cell(1,trial_num);
p_trace=cell(1,trial_num);


h = waitbar(0,'Please wait...');
for i=1:trial_num
    load(['Sti_',num2str(i),'_t.mat'])
    [length_pertrial,channels,n_reps]=size(StiTrlTrace);
%     big_spon=std(reshape(StiTrlTrace(1:2000,:,:),1,numel(StiTrlTrace(1:2000,:,:))));
    p_trace{i}=StiTrlTrace;
    for j=1:channels
%         spon_percon=mean(std(squeeze(StiTrlTrace(1:2000,j,:)),[],1));
        for k=1:n_reps
            clear tpdata;
            p_snip{i}{j,k}=[];
            p_wave{i}{j,k}=cell(1);
            tpdata=squeeze(StiTrlTrace(:,j,k));
            tpdata(3000:3120)=nan;
            tpdata(3000+30*stim_length(i):3000+30*stim_length(i)+120)=nan;
            
            tpthreshold=nanmean(tpdata(1:2000))+cri_spk.*nanstd(tpdata(1:2000));
            tp_idx=1;
            for ij=21:length(tpdata)-40
                if (tpdata(ij)+tpthreshold)>0 && (tpdata(ij+1)+tpthreshold)<0 && (tpdata(ij+2)+tpthreshold)<0  && (tpdata(ij+3)+tpthreshold)<0
                    p_snip{i}{j,k}(tp_idx)=ij;
                    p_wave{i}{j,k}{tp_idx}=tpdata(ij-20:ij+40);
                    tp_idx=tp_idx+1;
                end
            end
            
        end
    end
    waitbar(i/trial_num,h)
end

close(h)

%%






%%

all_wave=cell(1,trial_num);
all_snip=cell(1,trial_num);

h = waitbar(0,'Please wait...');
for i=1:trial_num
    clear tpdata;
    all_snip{i}=zeros(1,1);
    tpdata=p_wave{i};
    [n_chn,n_tri]=size(tpdata);
    for j=1:n_chn
        for k=4:19
            clear tp_pertrialdata tp_snip;
            tp_pertrialdata=p_wave{i}{j,k};
            tp_snip=p_snip{i}{j,k};
            
            if ~isempty(tp_snip)
                for l=1:length(tp_pertrialdata)
                    all_wave{i}=[all_wave{i} tp_pertrialdata{l}];
                    all_snip{i}=[all_snip{i} tp_snip(l)];
                end
            end
        end
    end
    waitbar(i/trial_num,h)
end

close(h)
%%

for ii=11
    figure;
    
    errorbar([-20:40]./30,nanmean(all_wave{ii},2),nanstd(all_wave{ii},[],2),'k','LineWidth',2)
    axis square;
    box off;
    set(gca,'TickDir','out','FontSize',30)
    xlabel('time (ms)','FontSize',30)
    ylabel('voltage (mv)','FontSize',30)
    xlim([-1 1.5])
    % axis([-1 1.5 -45 25])


    figure;errorbar([-20:40]./30,nanmean(all_wave{ii},2),nanstd(all_wave{ii},[],2)./sqrt(size(all_wave{ii},2)),'k','LineWidth',2)
    axis square;
    box off;
    set(gca,'TickDir','out','FontSize',30)
    xlabel('time (ms)','FontSize',30)
    ylabel('voltage (mv)','FontSize',30)
    xlim([-1 1.5])
    % axis([-1 1.5 -45 25])


    figure;
    plot([-20:40]./30,all_wave{ii}(:,1:100),'k')
    hold on;
    plot([-20:40]./30,nanmean(all_wave{ii},2),'r','LineWidth',3)
end


%%

% select_chan=[1,2,3,4,5,6,7,11];
select_chan=[11:15];
allwave=cell(1);

for i=1:length(select_chan)
    allwave{1}=[allwave{1} all_wave{select_chan(i)}];
end

%%

figure;
plot(allwave{1})

figure;
hold on;
plot([-20:40]./30,allwave{1}(:,3:5:end),'k')
hold on;
errorbar([-20:40]./30,nanmean(allwave{1},2),nanstd(allwave{1},[],2),'r','LineWidth',2)
axis square;
box off;
set(gca,'TickDir','out','FontSize',30)
xlabel('time (ms)','FontSize',30)
ylabel('voltage (mv)','FontSize',30)
xlim([-1 1.5])
% axis([-1 1.5 -55 45])


figure;
hold on;
errorbar([-20:40]./30,nanmean(allwave{1},2),nanstd(allwave{1},[],2),'k','LineWidth',2)
axis square;
box off;
set(gca,'TickDir','out','FontSize',30)
xlabel('time (ms)','FontSize',30)
ylabel('voltage (mv)','FontSize',30)
xlim([-1 1.5])
axis([-1 1.5 -45 35])


figure;
hold on;
plot([-20:40]./30,allwave{1}(:,3:3:end),'k')
hold on
errorbar([-20:40]./30,nanmean(allwave{1},2),nanstd(allwave{1},[],2)./sqrt(size(allwave{1},2)),'r','LineWidth',2)
axis square;
box off;
set(gca,'TickDir','out','FontSize',30)
xlabel('time (ms)','FontSize',30)
ylabel('voltage (mv)','FontSize',30)
xlim([-1 1.5])
% axis([-1 1.5 -45 25])

figure;
hold on;
plot([-20:40]./30,allwave{1}(:,500:820),'k')
hold on
plot([-20:40]./30,nanmean(allwave{1},2),'r','LineWidth',2)
axis square;
box off;
set(gca,'TickDir','out','FontSize',30)
xlabel('time (ms)','FontSize',30)
ylabel('voltage (mv)','FontSize',30)
xlim([-1 1.5])
% axis([-1 1.5 -45 25])


figure;
plot([-20:40]./30,allwave{1}(:,1:500),'k')
hold on;
plot([-20:40]./30,nanmean(allwave{1},2),'r','LineWidth',3)


%%


figure;

xxx=[-20:40]./30;
yyy=nanmean(allwave{1},2);
eee=nanstd(allwave{1},[],2)./sqrt(size(allwave{1},2));
confplot(xxx,yyy',eee')
axis square;
box off;
set(gca,'TickDir','out','FontSize',30)
xlabel('time (ms)','FontSize',30)
ylabel('voltage (mv)','FontSize',30)
xlim([-1 1.5])
% axis([-1 1.5 -45 25])

% hold on;
% plot([-20:40]./30,allwave{1}(:,3:5:end),'k')
% hold on

%%

figure;

xxx=[-20:40]./30;
xi=[-20./30:1./300:40./30];
yyy=nanmean(allwave{1},2);
eee=nanstd(allwave{1},[],2); %./sqrt(size(allwave{1},2));

yi=interp1(xxx,yyy,xi);
ei=interp1(xxx,eee,xi);

hold on;
plot([-20:40]./30,allwave{1}(:,500:820),'k')
hold on
errorbar(xi,yi,ei,'r')
hold on;plot(xi,yi,'b')

axis square;
box off;
set(gca,'TickDir','out','FontSize',30)
xlabel('time (ms)','FontSize',30)
ylabel('voltage (mv)','FontSize',30)
xlim([-1 1.5])

%%

used_wave_tp=[all_snip{11}(501:636) all_snip{12}(1:164)];

rsp_sn=find(used_wave_tp>3000 & used_wave_tp<6001);


%%

figure;

xxx=[-20:40]./30;
yyy=nanmean(allwave{1},2);
eee=nanstd(allwave{1},[],2)./sqrt(size(allwave{1},2));
hold on;
errorbar(xxx,yyy,eee,'r')

axis square;
box off;
set(gca,'TickDir','out','FontSize',30)
xlabel('time (ms)','FontSize',30)
ylabel('voltage (mv)','FontSize',30)
xlim([-1 1.5])

%%

p_spk_ts=cell(1,trial_num);


for i=1:trial_num
    clear tpdata;
    tpdata=p_snip{i};
    [n_chn,n_tri]=size(tpdata);
    for j=1:n_chn
        for k=1:n_tri
 %           p_spk_ts{i}{j,k}=(tt(p_snip{i}{j,k}));
              p_spk_ts{i}{j,k}=unique(round(tt(p_snip{i}{j,k})));
           % p_spk_ts{i}{j,k}=(round(tt(p_snip{i}{j,k})));
        end
    end
end

%%




%%

p_psth=cell(trial_num,n_chn);

h = waitbar(0,'Please wait...');
for i=1:trial_num
    [n_chn,n_tri]=size(p_spk_ts{i});
    for j=1:n_chn
        for k=1:n_tri
            clear tpdata;
            tpdata=p_spk_ts{i}{j,k};
            p_psth{i,j}(1:500,k)=zeros(1,500);
            for ll=1:length(tpdata)
%                 clear tpt;
%                 tpt=find(tt==tpdata(ll));
                p_psth{i,j}(tpdata(ll),k)=p_psth{i,j}(tpdata(ll),k)+1;
            end
        end
    end
    waitbar(i/trial_num,h)
end

close(h);

%%



m_psth=zeros(500,n_chn,trial_num);
m_psth_smth=zeros(500,n_chn,trial_num);

for i=1:trial_num
    for j=1:n_chn
        m_psth(:,j,i)=nanmean(p_psth{i,j},2);
        m_psth_smth(:,j,i)=smooth(nanmean(p_psth{i,j},2),2);
    end
end

%%
tst_data=p_psth{15,9};
[tm_lg,tri]=size(tst_data);
resp=[];
spns=[];
for i=1:tri
    resp(i)=nanmean(tst_data(106:195,i)).*1000;
    spns(i)=nanmean(tst_data([1:95,206:500],i)).*1000;
end

figure;
bar([1,2],[mean(spns) mean(resp)],'k'); 
hold on;
errorbar([1,2],[mean(spns) mean(resp)],[std(spns)./sqrt(length(spns)) std(resp)./sqrt(length(resp))],'ko','LineWidth',2)
axis square;
box off
set(gca,'TickDir','out')
xlabel('spontaneous             response','FontSize',30)
ylabel('event rate (hz)','FontSize',30)
set(gca,'FontSize',30)
xlim([0 3])


[h,p]=ttest(resp,spns)
[p,h]=ranksum(resp,spns)

title(['p=',num2str(p),' t-test'])

%%
use_condi=15;
use_channels=[6:9];
% use_tri=[3,3,3,43,43];
use_tri=[3,17,28,32,50];

psth_usecon=p_trace{use_condi};
[tp_triallength,tp_channel,tp_rept]=size(psth_usecon);

figure;
for i=1:length(use_channels)
    subplot(length(use_channels),1,i);
    plot(tt,smooth(psth_usecon(:,use_channels(i),50),10),'k','LineWidth',2);
%    plot(tt,smooth(psth_usecon(:,use_channels(i),50),10)-(i-1)*110,'k','LineWidth',2);
    hold on;
    axis off;
    xlim([50 300])
    ylim([-50 50])
    if i==length(use_channels)
        axis on;
        box off
        xlabel('time (ms)','FontSize',30)
        ylabel('voltage (uv)','FontSize',30)
        set(gca,'TickDir','out')
        set(gca,'FontSize',30)
    end
end

alldata=[tt;smooth(psth_usecon(:,use_channels(1),50),10)';smooth(psth_usecon(:,use_channels(2),50),10)';smooth(psth_usecon(:,use_channels(3),50),10)';smooth(psth_usecon(:,use_channels(4),50),10)'];

%%

filename='rawdata';
xlswrite(filename,alldata');

%%

use_condi=15;
use_channels=7;

use_trials=1:10;

psth_usecon=p_trace{use_condi};
figure;
for i=1:length(use_trials)
    subplot(length(use_trials),1,i);
    plot(tt,smooth(psth_usecon(:,use_channels,use_trials(i)),10),'k','LineWidth',1);
    axis off;
    ylim([-50 50])
end

%%

use_channels=4:19;
condition=15;


tpuse_psth=squeeze(m_psth(:,:,:));

[tptriallength,tpchannel,tpcondition]=size(tpuse_psth);
for i=1:tpchannel
    for j=1:tpcondition
        clear mytp;
        mytp=tpuse_psth(:,i,j);
        for k=2:tptriallength-1
            if mytp(k)>0.06
                tpuse_psth(k,i,j)=(mytp(k-1)+mytp(k+1))./2;
            end
        end
    end
end

for i=1:tpchannel
    for j=1:tpcondition
        clear mytp;
        mytp=tpuse_psth(:,i,j);
        for k=2:tptriallength-1
            if mytp(k)>0.06
                tpuse_psth(k,i,j)=(mytp(k-1)+mytp(k+1))./2;
            end
        end
    end
end


%%

maxcolor=max(max(max(tpuse_psth(:,use_channels,:))));

figure;
% subplot(1,2,1)
imagesc(tt,use_channels,tpuse_psth(:,use_channels,condition)');
box off
set(gca,'TickDir','out')
axis square
xlabel('time (ms)');
ylabel('channel')
title(['stimulus length ',num2str(stim_length(condition)),'     stimulus strength ',num2str(stim_strenth(condition))])
colorbar
caxis([0 0.1]);  %max(max(tpuse_psth(:,use_channels,condition)))]);

tp_spon=zeros(1,length(use_channels));
tp_resp=zeros(1,length(use_channels));
tp_spon_1=zeros(1,length(use_channels));
tp_resp_1=zeros(1,length(use_channels));
tp_spon_std=zeros(1,length(use_channels));
tp_resp_std=zeros(1,length(use_channels));

for i=1:length(use_channels)
    tp_spon(i)=nanmean(tpuse_psth([1:95,206:500],use_channels(i),condition)).*1000;
    tp_resp(i)=nanmean(tpuse_psth([106:195],use_channels(i),condition)).*1000;
    
    tp_spon_1(i)=nanmean(nanmean(p_psth{condition,use_channels(i)}([1:95,206:500],:)));
    tp_resp_1(i)=nanmean(nanmean(p_psth{condition,use_channels(i)}([106:195],:)));
    
    tp_spon_std(i)=nanstd(nanmean(p_psth{condition,use_channels(i)}([1:95,206:500],:),1));
    tp_resp_std(i)=nanstd(nanmean(p_psth{condition,use_channels(i)}([106:195],:),1));
end

% subplot(1,2,2);
figure;
plot(tp_spon,use_channels,'k','LineWidth',2)
hold on;plot(tp_resp,use_channels,'r','LineWidth',2)
set(gca,'ydir','reverse')
set(gca,'FontSize',30)
box off
set(gca,'TickDir','out')
axis square
ylabel('channel','FontSize',30);
xlabel('event rate (hz)','FontSize',30)

figure;
errorbar(use_channels,tp_spon_1.*1000,tp_spon_std.*1000./sqrt(51),'k','LineWidth',2)
hold on;
errorbar(use_channels,tp_resp_1.*1000,tp_resp_std.*1000./sqrt(51),'r','LineWidth',2)
%set(gca,'ydir','reverse')
set(gca,'FontSize',30)
box off
set(gca,'TickDir','out')
axis square
xlabel('channel','FontSize',30);
ylabel('event rate (hz)','FontSize',30)
%view([90 -90])


figure;
for i=1:3
    for j=1:5
        subplot(3,5,j+(i-1)*5)
        imagesc(tt,use_channels,tpuse_psth(:,use_channels,j+(i-1)*5)')
%         axis square;
        box off
        set(gca,'TickDir','out')
%         xlabel('time (ms)')
%         ylabel('channel')
%         title(['stimulus length ',num2str(stim_length(condition)),'     stimulus strength ',num2str(stim_strenth(condition))])
%         colorbar
        caxis([0 0.1])
    end
end



%%

use_channels=1:32;
condition=11;

maxcolor=max(max(max(m_psth(:,use_channels,:))));


clear tptpdata;
tptpdata=m_psth(:,use_channels,condition)';

if condition==12
    tptpdata(6:12,128)=nan;
    tptpdata(8:9,126)=nan;
end

if condition==11
    tptpdata(:,216)=nan;
end

figure;
% subplot(1,2,1)
imagesc(1:500,use_channels,tptpdata);
box off
set(gca,'TickDir','out')
axis square
xlabel('time (ms)');
ylabel('channel')
title(['stimulus length ',num2str(stim_length(condition)),'     stimulus strength ',num2str(stim_strenth(condition))])
colorbar
%caxis([0 max(max(m_psth(:,use_channels,condition)))]);
caxis([0 0.1] )

%%

tp_spon=zeros(1,length(use_channels));
tp_resp=zeros(1,length(use_channels));
tp_spon_1=zeros(1,length(use_channels));
tp_resp_1=zeros(1,length(use_channels));
tp_spon_std=zeros(1,length(use_channels));
tp_resp_std=zeros(1,length(use_channels));

for i=1:length(use_channels)
    tp_spon(i)=nanmean(m_psth([1:95,206:500],use_channels(i),condition)).*1000;
    tp_resp(i)=nanmean(m_psth([106:195],use_channels(i),condition)).*1000;
    
    tp_spon_1(i)=nanmean(nanmean(p_psth{condition,use_channels(i)}([1:95,206:500],:)));
    tp_resp_1(i)=nanmean(nanmean(p_psth{condition,use_channels(i)}([106:195],:)));
    
    tp_spon_std(i)=nanstd(nanmean(p_psth{condition,use_channels(i)}([1:95,206:500],:),1));
    tp_resp_std(i)=nanstd(nanmean(p_psth{condition,use_channels(i)}([106:195],:),1));
end

% subplot(1,2,2);
figure;
plot(tp_spon,use_channels,'k','LineWidth',2)
hold on;plot(tp_resp,use_channels,'r','LineWidth',2)
set(gca,'ydir','reverse')
set(gca,'FontSize',30)
box off
set(gca,'TickDir','out')
axis square
ylabel('channel','FontSize',30);
xlabel('event rate (hz)','FontSize',30)

figure;
errorbar(use_channels,tp_spon_1.*1000,tp_spon_std.*1000./sqrt(50),'k','LineWidth',2)
hold on;
errorbar(use_channels,tp_resp_1.*1000,tp_resp_std.*1000./sqrt(50),'r','LineWidth',2)
%set(gca,'ydir','reverse')
set(gca,'FontSize',30)
box off
set(gca,'TickDir','out')
axis square
xlabel('channel','FontSize',30);
ylabel('event rate (hz)','FontSize',30)
%view([90 -90])


figure;
for i=1:3
    for j=1:5
        subplot(3,5,j+(i-1)*5)
        imagesc(tt,use_channels,m_psth(:,use_channels,j+(i-1)*5)')
%         axis square;
        box off
        set(gca,'TickDir','out')
%         xlabel('time (ms)')
%         ylabel('channel')
%         title(['stimulus length ',num2str(stim_length(condition)),'     stimulus strength ',num2str(stim_strenth(condition))])
%         colorbar
        caxis([0 maxcolor])
    end
end

%%

select_chan=9;
tp_psth=cell(1,15);
tp_mpsth=zeros(1,15);
tp_stdpsth=zeros(1,15);
n_data=zeros(1,15);
sti_str=[20,40,60,80,100];
% stim_length=[10,10,10,10,10,50,50,50,50,50,100,100,100,100,100];

for i=1:15
    tp_psth{i}=p_psth{i,select_chan}.*1000;
    tp_mpsth(i)=nanmean(nanmean(tp_psth{i}(105:100+stim_length(i)-2,:)));
    tp_stdpsth(i)=nanstd(nanmean(tp_psth{i}(105:100+stim_length(i)-2,:)));
    n_data(i)=size(tp_psth{i},2);
end

figure;
for i=1:3
    errorbar(sti_str,tp_mpsth(i*5-4:i*5),tp_stdpsth(i*5-4:i*5)./sqrt(n_data(i)),'o-','Color',mycolor(floor(64/3*i),:),'LineWidth',2)
    hold on;
end
axis square;
box off
set(gca,'TickDir','out')
xlabel('strenth of stimulus','FontSize',30)
ylabel('response rate (Hz)','FontSize',30)
legend('10ms','50ms','100ms','FontSize',30)
set(gca,'FontSize',30)
axis([10 110 0 60])
%%

select_chan=9;
psth_perchan=squeeze((m_psth(:,select_chan,:)).*1000);
% psth_perchan=squeeze(nanmean(m_psth(:,:,:),2).*1000);

mycolor=colormap;
sti_str=[20,40,60,80,100];
sti_tm=[10,50,100];
figure;
for i=1:3
    plot(sti_str,nanmean(psth_perchan(104:100+sti_tm(i)-2,i*5-4:i*5),1),'o-','Color',mycolor(floor(64/3*i),:),'LineWidth',2);
    hold on;
end
axis square;
box off
set(gca,'TickDir','out')
xlabel('strenth of stimulus','FontSize',30)
ylabel('response rate (Hz)','FontSize',30)
legend('10ms','50ms','100ms','FontSize',30)
set(gca,'FontSize',30)
% axis([10 110 0.2 0.5])

figure;
cond=1;
for i=1:5
    plot(1:500,smooth(psth_perchan(:,i),5),'Color',mycolor(floor(64/5*i),:),'LineWidth',2);
    hold on;
end
axis square;
box off
set(gca,'TickDir','out')
xlabel('time (ms)','FontSize',30)
ylabel('response rate (hz)','FontSize',30)
legend('20','40','60','80','100')
title('10ms stimulus','FontSize',30)
set(gca,'FontSize',30)
xlim([50 250])
axis([50 250 0 80])


figure;
cond=2;
for i=1:5
    plot(1:500,smooth(psth_perchan(:,5+i),10),'Color',mycolor(floor(64/5*i),:),'LineWidth',2);
    hold on;
end
axis square;
box off
set(gca,'TickDir','out')
xlabel('time (ms)','FontSize',30)
ylabel('response rate (hz)','FontSize',30)
legend('20','40','60','80','100')
title('50ms stimulus','FontSize',30)
set(gca,'FontSize',30)
xlim([50 250])
axis([50 250 0 80])


figure;
cond=3;
for i=1:5
    plot(1:500,smooth(psth_perchan(:,10+i),10),'Color',mycolor(floor(64/5*i),:),'LineWidth',2);
    hold on;
end
axis square;
box off
set(gca,'TickDir','out')
xlabel('time (ms)','FontSize',30)
ylabel('response rate (hz)','FontSize',30)
legend('20','40','60','80','100')
title('100ms stimulus','FontSize',30)
set(gca,'FontSize',30)
xlim([50 250])
axis([50 250 0 80])

%%

psth_data=zeros(500,15);

for i=1:5
    psth_data(:,i)=smooth(psth_perchan(:,i),5);
end

for i=6:15
    psth_data(:,i)=smooth(psth_perchan(:,i),10);
end

filename='psth_all_conditions';
xlswrite(filename,psth_data);

%%

select_chan=11;
psth_perchan=p_psth(:,select_chan);
% psth_perchan=squeeze(nanmean(m_psth(:,:,:),2).*1000);

for i=1:15
    psth_perchan{i}=psth_perchan{i}.*1000;
end

mycolor=colormap;
sti_str=[20,40,60,80,100];
sti_tm=[10,50,100];



figure;
cond=1;
for i=1:5
    errorbar(1:500,smooth(nanmean(psth_perchan{i},2),2),nanstd(psth_perchan{i},[],2)./sqrt(50),'Color',mycolor(floor(64/5*i),:),'LineWidth',2);
    hold on;
end
axis square;
box off
set(gca,'TickDir','out')
xlabel('time (ms)','FontSize',30)
ylabel('response rate (hz)','FontSize',30)
legend('20','40','60','80','100')
title('10ms stimulus','FontSize',30)
set(gca,'FontSize',30)
xlim([50 250])
axis([50 250 0 500])


figure;
cond=2;
for i=1:5
    errorbar(1:500,smooth(nanmean(psth_perchan{i+5},2),2),nanstd(psth_perchan{i+5},[],2)./sqrt(50),'Color',mycolor(floor(64/5*i),:),'LineWidth',2);
    hold on;
end
axis square;
box off
set(gca,'TickDir','out')
xlabel('time (ms)','FontSize',30)
ylabel('response rate (hz)','FontSize',30)
legend('20','40','60','80','100')
title('50ms stimulus','FontSize',30)
set(gca,'FontSize',30)
xlim([50 250])
axis([50 250 0 500])


figure;
cond=3;
for i=1:5
    errorbar(1:500,smooth(nanmean(psth_perchan{i+10},2),10),nanstd(psth_perchan{i+10},[],2)./sqrt(50),'Color',mycolor(floor(64/5*i),:),'LineWidth',2);
%     plot(1:500,smooth(nanmean(psth_perchan{i+10},2),5),'Color',mycolor(floor(64/5*i),:),'LineWidth',2);
    hold on;
end
axis square;
box off
set(gca,'TickDir','out')
xlabel('time (ms)','FontSize',30)
ylabel('response rate (hz)','FontSize',30)
legend('20','40','60','80','100')
title('100ms stimulus','FontSize',30)
set(gca,'FontSize',30)
% xlim([50 250])
% axis([50 250 0 500])

%%


select_condition=15;
psth_percon=squeeze(m_psth(:,:,select_condition));

figure;
for i=1:32
    plot(1:500,psth_percon(:,i),'Color',mycolor(floor(64/32*i),:))
    hold on;
end
box off
set(gca,'TickDir','out')
xlabel('time (ms)')
ylabel('response rate (Hz)')

title(['stimulus length ',num2str(stim_length(condition)),'     stimulus strength ',num2str(stim_strenth(condition))])




























