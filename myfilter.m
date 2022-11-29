function improved=myfilter(winsize,signal,a,b)
%winsize=����
%a,b=����ϵ��
input=audioread(signal);%����wav�ļ�
size=length(input);%��������
numofwin=floor(size/winsize);%����
%���庺����
ham=hamming(winsize);
hamwin=zeros(1,size);
improved=zeros(1,size);
ytemp=audioread('P1bSeg-2.wav');
noisy=ytemp(33001:33000+winsize);
N=fft(noisy);
npow=abs(N);
Ps=zeros(winsize,1);
for q=1:2*numofwin-1
    yframe=input(1+(q-1)*winsize/2:winsize+(q-1)*winsize/2);%��֡
    hamwin(1+(q-1)*winsize/2:winsize+(q-1)*winsize/2)=hamwin(1+(q-1)*winsize/2:winsize+(q-1)*winsize/2)+ham';
    y1=fft(yframe.*ham);%�����ź�FFT
    ypow=abs(y1);%�����źŷ���
    yangle=angle(y1);%��λ
    %���㹦�����ܶ�
    Py=ypow.^2;
    Pn=npow.^2;
    %�׼�
    for i=1:winsize
        if Py(i)-a*Pn(i)>0
            Ps(i)=Py(i)-a*Pn(i);
        else
            Ps(i)=b*Pn(i);
        end
    end  
    %�ع�����
    s=sqrt(Ps).*exp(1i*yangle);
    %ȥ������IFFT
    improved(1+(q-1)*winsize/2:winsize+(q-1)*winsize/2)=improved(1+(q-1)*winsize/2:winsize+(q-1)*winsize/2)+real(ifft(s))';
end
for i=1:size  %ȥ��������������������
    if hamwin(i)==0
        improved(i)=0;
    else
        improved(i)=improved(i)/hamwin(i);
    end
end
