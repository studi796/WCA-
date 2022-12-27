function S_Model=Euclidean_NearTest(Design,n,p)
global Np;

temp=p;
m=size(p,1);
for i=1:m
    temp(i,Np+2)=0;
    for j=1:Np
        temp(i,Np+2)=temp(i,Np+2)+(temp(i,j)-Design(j))^2;
    end
end
[b,index]=sortrows(temp,Np+2);
S_Model=p(index(1:n),:);
end