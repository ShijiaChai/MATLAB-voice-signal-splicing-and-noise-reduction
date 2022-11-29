function improved=myfilter(winsize,signal,a,b)
%winsize=窗长
%a,b=修正系数
input=audioread(signal);%读入wav文件
size=length(input);%语音长度
numofwin=floor(size/winsize);%窗数
%定义汉明窗
ham=hamming(winsize);
hamwin=zeros(1,size);
improved=zeros(1,size);
ytemp=audioread('P1bSeg-2.wav');
noisy=ytemp(33001:33000+winsize);
N=fft(noisy);
npow=abs(N);
Ps=zeros(winsize,1);
for q=1:2*numofwin-1
    yframe=input(1+(q-1)*winsize/2:winsize+(q-1)*winsize/2);%分帧
    hamwin(1+(q-1)*winsize/2:winsize+(q-1)*winsize/2)=hamwin(1+(q-1)*winsize/2:winsize+(q-1)*winsize/2)+ham';
    y1=fft(yframe.*ham);%加噪信号FFT
    ypow=abs(y1);%加噪信号幅度
    yangle=angle(y1);%相位
    %计算功率谱密度
    Py=ypow.^2;
    Pn=npow.^2;
    %谱减
    for i=1:winsize
        if Py(i)-a*Pn(i)>0
            Ps(i)=Py(i)-a*Pn(i);
        else
            Ps(i)=b*Pn(i);
        end
    end  
    %重构语音
    s=sqrt(Ps).*exp(1i*yangle);
    %去噪语音IFFT
    improved(1+(q-1)*winsize/2:winsize+(q-1)*winsize/2)=improved(1+(q-1)*winsize/2:winsize+(q-1)*winsize/2)+real(ifft(s))';
end
for i=1:size  %去除汉明窗所带来的增益
    if hamwin(i)==0
        improved(i)=0;
    else
        improved(i)=improved(i)/hamwin(i);
    end
end
