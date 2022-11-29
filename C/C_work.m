tic
wp=[300 3200]/4000;
ws=[160 3950]/4000;
[n,wn]=buttord(wp,ws,3,40);
[b,a]=butter(n,wn);
plot(new);
for i=1:15
    name=['CSeg-',num2str(i),'.wav'];
    new1{i}=audioread(name);
    new1{i}=myfilter(160,name,3.94,0.001); 
    new1{i}=derevb1(new1{i},700);
    new1{i}=derevb1(new1{i},700);      
    mm(i)=max(abs(new1{i}));
    yf{i}=fft(new1{i});
    L(i)=length(new1{i});
    s{i}=(conj(fft(new1{i})).*fft(new1{i}));
    ss{i}=s{i}(1:floor(L(i)/16000*200));
    snr(i)=mean(s{i})/mean(ss{i});
    snr1(i)=mean(s{i})/mean(ss{i});
end 
maxsig=max(mm);
for i=1:15
    new1{i}=new1{i}/mm(i)*maxsig;
    new1{i}=filter(b,a,new1{i});
end

audiowrite('new9.wav',new1{9},8000);
for i=1:15
    for j=1:15
        [rm,t]=xcorr(new1{i},new1{j});
        [maxium,zz]=max(rm);
        yuzhi=15*mean(abs(rm));
        if (maxium>yuzhi)
            A(i,j)=t(zz);
        end
    end
end
adj=1;
index=zeros(15,2);
index(1,1)=1;
index(1,2)=length(new1{1});
for i=1:15
    line=adj(i);
    for j=1:15
        if(A(line,j)~=0)
            if(isempty(find(adj==j)))
                adj=[adj,j];
            end
            index(j,1)=A(line,j)+index(line,1)
            index(j,2)=index(j,1)+length(new1{j})-1
        end
    end
end
index=index-min(min(index))+1;
result=sort(index);
output=zeros(result(15,2),1);
while (any(snr))
    [maxs,ii]=max((snr));
    for jj=1:length(new1{ii})
        if (output(index(ii,1)+jj-1)==0)
            output(jj+index(ii,1)-1)=new1{ii}(jj);
        end
    end
    snr(ii)=0;
end
new=filter(b,a,output);
audiowrite('new.wav',new,8000);
toc
