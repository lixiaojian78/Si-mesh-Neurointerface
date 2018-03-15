
trial_num=15;

stim_length=[10,10,10,10,10,50,50,50,50,50,100,100,100,100,100];
stim_strenth=[20,40,60,80,100,20,40,60,80,100,20,40,60,80,100];


cri_spk=5;
tt=0:1/30:250;

%%



p_snip=cell(1,trial_num);
p_wave=cell(1,trial_num);
p_trace=cell(1,trial_num);


h = waitbar(0,'Please wait...');
for i=1:trial_num
    load(['Sti_',num2str(i),'_t.mat'])
    [length_pertrial,channels,n_reps]=size(StiTrlTrace);
    big_spon=std(reshape(StiTrlTrace(1:2000,:,:),1,numel(StiTrlTrace(1:2000,:,:))));
    p_trace{i}=StiTrlTrace;
    for j=1:channels
        spon_percon=mean(std(squeeze(StiTrlTrace(1:2000,j,:)),[],1));
        for k=1:n_reps
            clear tpdata;
            p_snip{i}{j,k}=[];
            p_wave{i}{j,k}=cell(1);
            tpdata=squeeze(StiTrlTrace(:,j,k));
            tpdata(1500:1620)=nan;
            tpdata(1500+30*stim_length(i):1500+30*stim_length(i)+120)=nan;
            
            tpthreshold=nanmean(tpdata(1:1000))+cri_spk.*nanstd(tpdata(1:1000));
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

figure;
for i=1:15
    subplot(3,5,i);
    imagesc(1000.*m_psth(:,:,i)');
end


%%
channels=12:18;
spon_edtime=250;

%%

sti_data=cell(1);
spon_data=cell(1);
m_sti_data=cell(1);
m_spon_data=cell(1);

for i=1:15
    sti_data{i}=m_psth(51:100+stim_length(i),channels,i);
    m_sti_data{1}(:,i)=1000.*mean(sti_data{i},1);
    spon_data{i}=m_psth(51+stim_length(i):spon_edtime,channels,i);
    m_spon_data{1}(:,i)=1000.*mean(spon_data{i},1);
end

figure;
for i=1:15
    subplot(3,5,i);
    plot(m_spon_data{1}(:,i),'k')
    hold on;
    plot(m_sti_data{1}(:,i),'r')
end

%%

figure;
m_data=reshape(m_sti_data{1},1,numel(m_sti_data{1}));
m_spon=reshape(m_spon_data{1},1,numel(m_spon_data{1}));

scatter(m_data,m_spon,'k')
hold on;
plot(0:250,0:250,'r')

X=[m_data;m_spon]';
figure;boxplot(X)

%%

% save 





