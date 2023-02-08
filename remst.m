function [ f1,RRn1 ] = remst(x, fs1)
%REMUESTREAR Y QUITAR TENDENCIA

t=(cumsum(x));
p1 = polyfit(t,x,3);
f1 = polyval(p1,x);


tn1=[t(1):(1/fs1):t(end)];
signalnew1=spline(t,f1,tn1);
RRn1=signalnew1;
RRn1=RRn1-mean(RRn1);
RRn1=RRn1*1000;%RR EN MS


end

