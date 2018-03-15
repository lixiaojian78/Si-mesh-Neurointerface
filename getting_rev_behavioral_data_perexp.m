
% for the behavioral data of 20180128

leftM1_data_fd=1:5;
rightM1_data_fd=6:10;

n_sd=5;
n_data=2;
add=1;
sn_percondi=[];
all_data_left=[];
all_data_orthhand=[];
peak_res=[];
peak_time=[];
for i=1:5   % this is for data stimulating left M1
    cd([num2str(i)])
    for j=1:n_data
        clear tpmnx tpnd tpsn;
        load(['F_MD_Sti_',num2str(j),'.mat']);
        tpnd=nd;
        tpmnx=zeros(size(tpnd,1),4,2);
        [tpmnx(:,1,1),tpmnx(:,2,1)]=max(abs(tpnd(:,:,3)'));
        [tpmnx(:,1,2),tpmnx(:,2,2)]=max(abs(tpnd(:,:,4)'));
        [tpmnx(:,4,1)]=std(nd(:,:,3),[],2);
        [tpmnx(:,4,2)]=std(nd(:,:,4),[],2);
        tpmnx(tpmnx(:,1,1)>n_sd.*tpmnx(:,4,1),3,1)=1;
        tpmnx(tpmnx(:,1,2)>n_sd.*tpmnx(:,4,2),3,2)=1;
        
        tpsn=find(tpmnx(:,3,1)>0  & tpmnx(:,2,1)<70 & tpmnx(:,2,1)>49  & tpmnx(:,1,2)<tpmnx(:,1,1));
        
        sn_percondi(i,j)=length(tpsn);
        if ~isempty(tpsn)
            for k=1:length(tpsn)
                all_data_left(:,add)=squeeze(tpnd(tpsn(k),:,3))';
                all_data_orthhand(:,add)=squeeze(tpnd(tpsn(k),:,4))';
                peak_res(add)=tpmnx(tpsn(k),1,1);
                peak_time(add)=tpmnx(tpsn(k),2,1);
                add=add+1;
            end
        end
    end
    cd ..
end

%%

figure;errorbar(1:100,mean(all_data_left,2),std(all_data_left,[],2)./sqrt(size(all_data_left,2)))

figure;
for i=1:15
    subplot(3,5,i)
    plot(all_data_left(:,i))
end


figure;errorbar(1:100,mean(all_data_orthhand,2),std(all_data_orthhand,[],2)./sqrt(size(all_data_orthhand,2)))

%%

max_bf=max(abs(all_data_left(21:48,:)));
max_af=max(abs(all_data_left(51:100,:)));
max_bf_other=max(abs(all_data_orthhand(1:48,:)));
max_af_other=max(abs(all_data_orthhand(51:100,:)));

figure;
scatter(max_bf,max_af,'ko')
hold on;
plot(0:8,0:8,'r--')
axis square;
box off
set(gca,'TickDir','out','FontSize',20)
xlabel('max amplitude before stimulation (pixel)','FontSize',20)
ylabel('max amplitude after stimulation (pixel)','FontSize',20)
title(['n=',num2str(size(all_data_left,2))])

%%
save 20180131_alldata_mouse1

%%




%%

n_sd=5;
n_data=[2,2,2,15,15];
add=1;
sn_percondi=[];
all_data_right=[];
all_data_orthhand=[];
peak_res=[];
peak_time=[];
for i=6:10   % this is for data stimulating left M1
    cd([num2str(i)])
    for j=1:n_data(i-5)
        clear tpmnx tpnd tpsn;
        load(['F_MD_Sti_',num2str(j),'.mat']);
        tpnd=nd;
        tpmnx=zeros(size(tpnd,1),4,2);
        [tpmnx(:,1,1),tpmnx(:,2,1)]=max(abs(tpnd(:,:,3)'));
        [tpmnx(:,1,2),tpmnx(:,2,2)]=max(abs(tpnd(:,:,4)'));
        [tpmnx(:,4,1)]=std(nd(:,:,3),[],2);
        [tpmnx(:,4,2)]=std(nd(:,:,4),[],2);
        tpmnx(tpmnx(:,1,1)>n_sd.*tpmnx(:,4,1),3,1)=1;
        tpmnx(tpmnx(:,1,2)>n_sd.*tpmnx(:,4,2),3,2)=1;
        
        tpsn=find(tpmnx(:,3,1)>0  & tpmnx(:,2,1)<70 & tpmnx(:,2,1)>49 & tpmnx(:,1,1)>tpmnx(:,1,2));
        
        sn_percondi(i,j)=length(tpsn);
        if ~isempty(tpsn)
            for k=1:length(tpsn)
                all_data_right(:,add)=squeeze(tpnd(tpsn(k),:,3))';
                all_data_orthhand(:,add)=squeeze(tpnd(tpsn(k),:,4))';
                peak_res(add)=tpmnx(tpsn(k),1,1);
                peak_time(add)=tpmnx(tpsn(k),2,1);
                add=add+1;
            end
        end
    end
    cd ..
end

%%

figure;errorbar(1:100,mean(all_data_right,2),std(all_data_right,[],2)./sqrt(size(all_data_right,2)))

figure;
for i=1:12
    subplot(3,4,i)
    plot(all_data_right(:,i))
end

figure;
for i=1:12
    subplot(3,4,i)
    plot(all_data_right(:,i+12))
end



%%

max_bf=max(abs(all_data_right(21:48,:)));
max_af=max(abs(all_data_right(51:100,:)));
max_bf_other=max(abs(all_data_orthhand(1:48,:)));
max_af_other=max(abs(all_data_orthhand(51:100,:)));

figure;
scatter(max_bf,max_af,'ko')
hold on;
plot(0:8,0:8,'r--')
axis square;
box off
set(gca,'TickDir','out','FontSize',20)
xlabel('max amplitude before stimulation (pixel)','FontSize',20)
ylabel('max amplitude after stimulation (pixel)','FontSize',20)
title(['n=',num2str(size(all_data_right,2))])

%%
save 20180131_alldata_mouse2
















