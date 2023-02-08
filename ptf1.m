function [DRR,qrsi]=ptf1(s)
f1=5;
f2=15;
fs=1000;
Wn=[f1/(fs/2) f2/(fs/2)];

%%
%filtro iir
[b,a] = butter(3,Wn,'bandpass');
z2=filtfilt(b,a,s);
figure(1)
subplot(1,2,1);plot(s); title('ecg');subplot(1,2,2);plot(z2);title('filtrado iir');
%filtro fir
d=fir1(500,f2/(fs/2));
e=fir1(500,f1/(fs/2),'high');
firecg=filtfilt(d,1,s);
firecg1=filtfilt(e,1,firecg);
figure(2)
subplot(1,2,1);plot(s); title('ecg');subplot(1,2,2);plot(firecg1);title('filtrado fir');
ecgn= s/max(z2);
%filtro derivativo
hz=(fs*1/8)*[-1 -2 0 2 1];
ecgd=conv(ecgn,hz);
ecgd=ecgd/max(ecgd);
%filtro derivativo con diff
ecgdif=diff(ecgn);
figure(3)
subplot(1,2,1);plot(ecgdif); title('derivada diff');subplot(1,2,2);plot(ecgd);title('derivada');
%%
%cuadratura
ecgc=ecgd.*ecgd;
ecgc=ecgc/max(ecgc);
ecgc1=ecgdif.*ecgdif;
ecgc1=ecgc1/max(ecgc1);
figure(4)
subplot(1,2,1);plot(ecgc1); title('cuadratura diff');subplot(1,2,2);plot(ecgc);title('cuadratura');
%%
%integracion de ventana 
WindowSize=0.150*fs;
b=(1/WindowSize)*ones(1,WindowSize);
a=1;
ecgv=filtfilt(b,a,ecgc);
ecgv=ecgv/max(ecgv);
ecgv1=filtfilt(b,a,ecgc1);
ecgv1=ecgv1/max(ecgv1);
fs=1000;
ts=0.3;
[pks,locs]=findpeaks(ecgv,'MINPEAKDISTANCE',round(0.2*fs));
figure(5)
subplot(1,2,1);plot(ecgv1); title('ventana diff');subplot(1,2,2);plot(locs,pks);title('ventana');
senalf=z2;
long=length(locs);
picof=zeros(long);
locf=zeros(long);
iv=0;
%% inicializacion
%requiere cerca de 2 segundos para inicializar los umbrales de deteccion
%basados y los picos de ruido detectados durante el proceso de aprendizaje
umbralpicov= max(ecgv(1:2*fs))*(1/4) %Es el 0.25 de la señal filtrada y corresponde a SPKI 
umbralruidov= max(ecgv(1:2*fs))*(1/2) %Es el 0.5 de la señal filtrada y corresponde a NPKI 
nivelsigvp=umbralpicov;
nivelsigvr=umbralruidov;
umbralpicof= max(senalf(1:2*fs))*(1/4) %Es el 0.25 de la señal filtrada y corresponde a SPKI 
umbralruidof= max(senalf(1:2*fs))*(1/2) %Es el 0.5 de la señal filtrada y corresponde a NPKI 
nivelsigfp=umbralpicof;
nivelsigfr=umbralruidof;
%%  % ciclo para encontrar los picos de la señal filtrada asi como la
% localizacion de estos
  for i=1:length(locs) %recorre la localizacion de los picos encontrados en la ventana movil
    
  iv=(locs(i)-(0.15*fs)); %se inicia la ventana
  
    if(iv <=0)% si la ventana es menor o igual a 150ms
        % solo se utiliza para encontrar el primer pico de la señal
        % filtrada
        Pp = max(senalf((1:(locs(i))))); %pico de señal filtrada
        picof(i,:)=Pp; %se guarda el pico
        locf(i,:)= find(senalf == max(Pp)); %se encuentra la localizacion del pico cuando la señal es igual al pico 
       else
      
        Pp = max(senalf((iv):(locs(i)))); 
        picof(i,:)=Pp;
        locf(i,:)= find(senalf == max(Pp));
      
    
    end
  end
  
  
  %% Discriminación de onda T
 us=umbralpicov;
 usf=umbralpicof;
 lqrsi=[];
 hv=ecgv;
 h=0; %variable que indica cuando ya se detecto un QRS (cuando es 1)
 nrf=nivelsigfr;
 nr=nivelsigvr;
 qrsi=[];
 ur=umbralruidov;
 urf=umbralruidof;
 DRR=[];
 j=0;
 for i=1:length(pks)
        a=0;
        
        if ((pks(i)> us) && (picof(i)>usf)&& h==1 )%se verifican umbrales
        a=1; %variable que asegura que existe un qrs
    
           %se verifica si puede haber una onda T
           if(locs(i)-lqrsi(end))<(0.3600*fs) %si la localizacion del pico vi - loc del vector a crear es menor a 360ms se verifica si es onda t o qrs
               s1=mean(diff(hv(locs(i)-(0.075*fs):locs(i))));
               s2=mean(diff(hv(lqrsi(end)-(0.075*fs):lqrsi(end))));
               %si la maxima pendiente que ocurre durante esta forma de
               %onda es menor que la mitad que aquella de la forma de QRS
               %que la presedio, es identificada para ser una onda t, si no
               %es qrs
               
               if (abs(s1)<=abs(0.5*(s2)))
                   %la onda t entra aqui y se actualizan los umbrales
                   a=0; 
                   nrf=0.125*picof(i)+0.875*(nrf);
                   nr=0.125*pks(i)+.0875*(nr);
                   ua=1;
                   
               %si no se detecta onda T, se guarda el picco en el vector QRS     
               else
               qrsi(i)=picof(i); %pico qrs
               lqrsi(i)=locf(i); %localizacion qrs
               
               end
           else %si la localizacion no es menor es un qrs
           qrsi(i)=picof(i); %si no hay
           lqrsi(i)=locf(i);
           
           end 
               
        else %cuando se guarda el primer QRS
           if ((pks(i)>us) && (picof(i)>usf)) %si los picos de las señales son mayores a los umbrales se guarda el QRS
                   qrsi(1)=picof(i);
                   lqrsi(1)=locf(i);
                   h=1;
           end
        end
        if ((pks(i)>ur) && (pks(i)<us))
            nrf=0.125*picof(i)+0.875*(nrf);
            nr=0.125*pks(i)+.0875*(nr);
            ua=1;
        end
        if (pks(i)< ur)
            nrf=0.125*picof(i)+0.875*(nrf);
            nr=0.125*pks(i)+.0875*(nr);
            ua=1;
        end
        
 end
sumao=0;
 c=length(lqrsi);
 for i=1:c
     if(lqrsi(i)==0)&&(lqrsi(i+1)~=0)
         sumao=sumao+1;
     end
 end
    
 for i=1:(c-sumao)
if(lqrsi(i)==0)
    lqrsi(i)=[];
     end
 end 
 for i=1:(c-sumao)
     if(lqrsi(i)==0)
         lqrsi(i)=lqrsi(i+1);
     end
 end
%% Ajuste de intervalo RR y limites de tasa
%con a checas si hay qrs
% fase de aprendizaje 2, se requieren 2 latidos para inicializar el
% promedio y los valores limites
for i=1:(c-sumao)%length(lqrsi)
 
if (i>=2) %&& (a==1)  
       DRR(i)=(lqrsi(i)-lqrsi(i-1)); %calcula distancia de un r a otro
      
end 
     
 if(qrsi(i)==0)
     qrsi(i)=[];
 end
if(length(DRR)>8) %si es mayor a 8 empieza a calcular los promedios
         sumaRR=0;
          for j=1:8
          sumaRR=sumaRR+DRR(end-j);  
          end
             mDRR=sumaRR/8; %promedio de los 8 rr basado en los 8 mas recientes
         if((lqrsi(end)<=0.92*mDRR)||(lqrsi(end)>=1.16*mDRR))  
            %Si el RR no se encuentra en el rango adecuado actualizamos los
            %umbralespara que entren dentro de ese rango:
            
            us = 0.5*us;
            usf = 0.5*usf; 
           
         end
         
         if((locs(i)-lqrsi(end))>=round(1.66*mDRR))&&(i<1705) % si es mayor al 166% Buscamos un QRS perdido
            
             qrs_temp=max(ecgv(lqrsi(end)+round(0.200*fs):locs(i)-round(0.200*fs))); %encontrar el pico maximo  en la señal de vi
            loc_temp=find(ecgv == max(qrs_temp)); % encuentras localizacion del pico de la señal de ventana
            qrs_tempF =max(senalf(lqrsi(end)+round(0.200*fs):locf(i)-round(0.200*fs)));%lo mismo para la filtrada
            loc_tempF=find(senalf == max(qrs_tempF));
         if(qrs_temp>ur )&& (qrs_tempF>urf) %si son mayores a sus umbrales es un qrs
              qrsi(i)=qrs_tempF;
              lqrsi(i)=loc_tempF;
              
              nivelsigfp=0.25*(qrs_tempF)+0.75*nivelsigfp; %ajuste de umbrales
              nivelsigvp=0.25*(qrs_temp)+0.75*nivelsigvp;
         end
           end
          end
      
       
      %Actualizamos umbrales
      
      us = nr + 0.25*(abs(nivelsigvp-nr));
      ur = 0.5*us;
        
      usf = nrf + 0.25*(abs(nivelsigfp - nrf));
      urf=0.5*us; 

       
 end  
lqrsi1=lqrsi;
 for i=1:(c-sumao)
     if(DRR(i)==0)
         DRR(i)=DRR(i+1);
     end
   if(qrsi(i)==0)
         qrsi(i)=qrsi(i+1);
   end
 end   
tiempo=(1:length(s))/fs;
%%       
figure(6)
hold on 
plot(tiempo,s);
plot(tiempo(lqrsi1),s(lqrsi1),'r*');
