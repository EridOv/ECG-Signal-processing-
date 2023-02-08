function [pxx, f1,uf,vlf,lf,hf,ptotal,hfnorm,lfnorm,lfhf]=indicesenfrecuencia2(s,fs1)
tiempo=cumsum(s);
s1=detrend(s);
fs3=2;
timenew1=[tiempo(1):(1/fs3):tiempo(end)];
signew1=spline(tiempo,s1,timenew1);
RRn1=signew1;
RRn1=RRn1-mean(RRn1);
RRn1=RRn1*1000;

[pxx,f1]=periodogram(RRn1,[],[],2);
nfft=2^nextpow2(length(pxx));
freq=fs3/2*linspace(0,1,nfft/2+1);


%[ f1,pxx ] = remst(s, fs1);
uf=sum(pxx(find(f1>=0 & f1<0.0033)));
vlf=sum(pxx(find(f1>=0.0033 & f1<0.04)));
lf=sum(pxx(find(f1>=0.04 & f1<0.15)));
hf=sum(pxx(find(f1>=0.15 & f1<0.4)));
ptotal= uf+vlf+lf+hf;
hfnorm=(hf/(ptotal-vlf-uf))*100;
lfnorm=(lf/(ptotal-vlf-uf))*100;
lfhf=lf/hf;
end
