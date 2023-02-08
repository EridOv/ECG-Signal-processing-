function [ RR_snt1 ] = sintsa( Y )
%QUITAR LA TENDENCIA 
RR_snt=detrend(Y);
%QUITANDO ARTEFACTOS CON FILTRO DE MEDIA 
RR_snt1= medfilt1(RR_snt,6);
end

