function [RRn1 ] = remm( Y,fs1)
%REMUESTREAR 
t=(cumsum(Y));%VECTOR DE TIEMPO
tn1=[t(1):(1/fs1):t(end)];
signalnew1=spline(t,Y,tn1);
RRn1=signalnew1;
RRn1=RRn1-mean(RRn1);
RRn1=RRn1*1000;      

end

