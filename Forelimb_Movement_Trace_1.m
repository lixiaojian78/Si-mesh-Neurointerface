clear
[filename, pathname] = uigetfile('*.bmp', 'Select a bmp file');
cd (pathname);
dirinfo1 = dir('*.bmp');
Nf = size(dirinfo1,1);

for i = 1:Nf
    filename = dirinfo1(i).name;
f1 = strfind(filename,'-');
f2 = strfind(filename,'.bmp');
fn = str2num(filename(3:f1-1));
ft = str2num(filename(f1+1:f2-1));
ff(i,1) = fn;
ff(i,2) = ft;
end

[B,I] = sort(ff(:,1));
for i = 1:size(ff,1)
    B(i,2) = ff(I(i),2);
end

for i = 2:size(ff,1)
    B(i,3) = B(i,2) - B(i-1,2);
end

j = 1;
for i = 1:size(ff,1)
    if B(i,3) >= 500
        v(j,1) = B(i,3);
        v(j,2) = i;
        j = j + 1;
    end
end

nf = 100;
k = 0;
for i = 2:size(v,1)
    v(i,3) = v(i,2) - v(i-1,2);
    if v(i,3) ~= 100
        k = k + 1;
    end
end

%nf = 100;
%if k == 0
    st = v(1,2) - nf;
    %for i = 1: size(v,1)%+1
    for i = 1: size(B,1)/nf
        for j = 1:nf
        Vd{i,j} = B((i-1)*nf+st-2+j,1:2);
        end
    end
%end
        
Read_Param_File_1;

for i = 1:size(Sti_Sequence,2)
    for j = 1:size(Sti_Sequence,2)
        if Sti_Sequence(j) == i-1
        Sti_Loc(i,1) = j;
        break;
        end
    end
end

ntr = ceil(size(Vd,1) ./ size(Sti_Loc,1));
for i = 1:size(Sti_Loc,1)
    for j = 1:ntr
        if size(Sti_Loc,1)*(j-1) + Sti_Loc(i,1) <= size(Vd,1)
            VS{i,j} = size(Sti_Loc,1)*(j-1) + Sti_Loc(i,1);
            %VL{i,j,:} = Vd{VS{i,j},:};
        end
    end
end
    
CF = pwd;

SaveDataMatrix = uigetdir;
%mkdir([CF SaveDataMatrix]);
%%
cd (SaveDataMatrix);
save('VS','VS', '-v7.3');
save('Vd','Vd', '-v7.3');
cd (CF);

for k = 1:size(VS,1)
    
    for j = 1:size(VS,2)
        if VS{k,j} > 0
            for i = 1:size(Vd,2)
                C{i,j}(:,:) = imread(['tt', num2str(Vd{VS{k,j},i}(1)), '-', num2str(Vd{VS{k,j},i}(2)),'.bmp']);
            end
        end
    end
    
    
    cd (SaveDataMatrix);
    save(['Sti_', num2str(k)],'C', '-v7.3');
    
    cd (CF);
    clear C
end
    
%%
clear
dirinfo1 = dir('Sti_*.mat');
Nf = size(dirinfo1,1);

for f  = 1:Nf
    load(dirinfo1(f).name);

for j = 1:size(C,2)
    for i = 1:size(C,1)
        left = C{i,j}(321:470,351:500);   %%%%%
        [l(i,1), l(i,2), l(i,3)] = center_point_1(left);
        right = C{i,j}(321:470,141:290);  %%%%%
        [r(i,1), r(i,2), r(i,3)] = center_point_1(right);
    end

    for i = 1:size(C,1)
        d(j,i,1) = sqrt(l(i,1)*l(i,1) + l(i,2)*l(i,2));
        d(j,i,2) = sqrt(r(i,1)*r(i,1) + r(i,2)*r(i,2));
    end
end


aa = dirinfo1(f).name;
bb = aa(1:size(aa,2)-4);
save(['MD_', bb],'d', '-v7.3');
clear C l r d
end

clear
disp('done !')

%%
dirinfo1 = dir('MD_*.mat');
Nf = size(dirinfo1,1);
close all

for f  = 1:Nf
    load(dirinfo1(f).name);
    ntrl = size(d,1);
    figure(f);
    for i = 1:ntrl
        subplot(ceil(ntrl/2),2,i);
        hold on
        d1(:,1) = d(i,:,1)- mean(d(i,:,1));
        d3 = BandpassBWfilter(d1,100,3,45);
        d2(:,1) = d(i,:,2)- mean(d(i,:,2));
        d4 = BandpassBWfilter(d2,100,3,45);
        %d2 = BandpassBWfilter(d(i,:,2)- mean(d(i,:,2)'),100,2,50);
        plot(d3,'r');
        plot(d4,'b');
        
        plot(d1,'y');
        plot(d2,'g');
        xlabel(num2str(i));
    
    nd(i,:,1) = d1;
    nd(i,:,2) = d2;
    nd(i,:,3) = d3;
    nd(i,:,4) = d4;
    end
    aa = dirinfo1(f).name;
    bb = aa(1:size(aa,2)-4);
    save(['F_', bb],'nd', '-v7.3');
    clear d d1 d2 d3 d4 nd aa bb
end

function out = BandpassBWfilter(in, fSample, fCutoff1,fCutoff2)

bpFilt = designfilt('bandpassiir','FilterOrder',2*2, ...
         'HalfPowerFrequency1',fCutoff1,'HalfPowerFrequency2',fCutoff2, ...
         'SampleRate',fSample);
out = filter(bpFilt,in);
out(1,:) = in(1,:);  
out(2,:) = in(2,:);
return

