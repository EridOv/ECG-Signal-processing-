function [ SD1,SD2 ] = SD(rr )
ki=length(rr);

rr1=rr(2:ki); 
rr2=rr(1:ki-1);

X1=(rr2-rr1)*(1/sqrt(2));
X2=(rr2+rr1)*(1/sqrt(2));
SD1=sqrt(var(X1));
SD2=sqrt(var(X2));
end

