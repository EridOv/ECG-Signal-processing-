function [ tt2,p2 ] = Tt( P ,Q);
a=ttest(P);
b=ttest(Q);

if(a==1&b==1);
[tt2,p2]=ttest2(P,Q);
else 
   display('error')
    

end

end

