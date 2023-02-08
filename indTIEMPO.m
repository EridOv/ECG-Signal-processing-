function [ medY1,SDNN,RMSSD1Y1,rr1Y1,rr2Y1,SD1Y1,SD2Y1,R1 ] = indTIEMPO( Y1 )
%INDICES EN TIEMPO
%%  %%MEDIA 
medY1=mean(Y1);

%% %SDNN
SDNN = std(Y1);

%%  %RMSSD
RMSSD1Y1=RMSSD(Y1);

%% %SD1 y SD2, R=SD1/SD2
 [ rr1Y1,rr2Y1,SD1Y1,SD2Y1,R1] = gpc(Y1 );

end

