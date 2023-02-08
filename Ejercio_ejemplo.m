%EXAMEN PRACTICO 1
%ERICKA DEYANIRA OVANDO BECERRIL
X=load('Ej1_qrs.mat');
% INTERVALOS RR
l=length(posQRS); 
rri=posQRS(1:l-1);
rrii=posQRS(2:l);
intRR=(rrii-rri);

[ medY1s1a,SDNNs1a,RMSSD1Y1s1a,rr1Y1s1a,rr2Y1s1a,SD1Y1s1a,SD2Y1s1a,R1s1a ] = indTIEMPO( intRR );
[ rr1s1a,rr2s1a,SD1s1a,SD2s1a,Ps1a ] = gpc( intRR);

%graficar
figure(2)
subplot(2,2,1),plot(rr1s1a,rr2s1a,'*r'); title('s1a'), xlabel('RR(n+1)') ,ylabel('RR(n)');
subplot(2,2,2),plot(intRR);
figure(2)
%Calcula	todos	los	índices	de	VFC en	el	dominio	de	la	frecuencia.
[x,f,ufa1,vlfa1,lfa1,hfa1,ptotala1,hfnorma1,lfnorma1,lfhfa1]=indicesenfrecuencia(intRR,500);
[x1,f1,ufa12,vlfa12,lfa12,hfa12,ptotala12,hfnorma12,lfnorma12,lfhfa12]=indicesenfrecuencia2(intRR,500);

%%REPORTE DE RESULTADOS
disp('INDICES EN TIEMPO');
disp('MEDIA SEGMENTO A1'),disp(medY1s1a);
disp('STD SEGMENTO A1'),disp(SDNNs1a);
disp('RMSSD SEGMENTO A1'),disp(RMSSD1Y1s1a);
disp('SD1'),disp(SD1s1a);
disp('SD2'),disp(SD2s1a);

disp('INDICES EN FRECUENCIA CON FUNCIÓN PWECH');
disp('HF SEGMENTO A1'),disp(hfa1);
disp('LF SEGMENTO A1'),disp(lfa1);
disp('uLFn SEGMENTO A1'),disp(ufa1);
disp('vLFn SEGMENTO A1'),disp(vlfa1);
disp('PotenciaTotal SEGMENTO A1'),disp(ptotala1);
disp('hf normalizada SEGMENTO A1'),disp(hfnorma1);
disp('lf normalizada SEGMENTO A1'),disp(lfnorma1);

disp('INDICES EN FRECUENCIA CON FUNCIÓN /PERIODOGRAM');
disp('HF SEGMENTO A1'),disp(hfa12);
disp('LF SEGMENTO A1'),disp(lfa12);
disp('uLFn SEGMENTO A1'),disp(ufa12);
disp('vLFn SEGMENTO A1'),disp(vlfa12);
disp('PotenciaTotal SEGMENTO A1'),disp(ptotala12);
disp('hf normalizada SEGMENTO A1'),disp(hfnorma12);
disp('lf normalizada SEGMENTO A1'),disp(lfnorma12);
%FRECC CARDIACA
fcmeds=(intRR/(500));
fcmean=mean(60./fcmeds)
fcstd=std(60./fcmeds)

 %%grafica espectro de potencia 
figure(3)
plot(f,x),xlabel('Hz'),ylabel('ms^2');
% axis([.0001 0.4 0 300000000000000]);
figure(4)
plot(f1,x1,'r'),xlabel('Hz'),ylabel('ms^2');
% axis([.0001 0.4 0 300000000000000]);



