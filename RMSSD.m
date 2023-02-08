% FUNCION QUE DEVUELVE INDÍCE RMSSD DONDE n ES  EL NUMERO DE ELEMENTOS DEL
% VECTOR Y senal ES EL VECTOR QUE RECIBE.



function [RMSSD1]=RMSSD(senal)

suma=0;
 N=length(senal);
for i=1:N-1
     a = (senal(i+1)-senal(i))^2; 
     suma=suma+a;
 end;
 RMSSD2=(1/(N-1))*suma;
 RMSSD1=sqrt(RMSSD2);
end

 
 
 

