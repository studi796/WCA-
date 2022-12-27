function Rank=Rank_dominant_based(x)
global Degree_violation_max constraints;
global t T;
cp=0.5;
if t<T
    Degree_violation=Degree_violation_max*((1-t/T)^cp);
else
    Degree_violation=zeros(1,4);
end
a=size(x,1);
b=size(x,2);
x_extent=zeros(a,b+2);
x_extent(:,b)=x;
for i=1:a
    for j=Np+1:Np+4
        x_extent(i,b+2)=x_extent+(x(i,j)-constraints(j-Np))/constraints(j-Np)^2;
    end
end

for i=1:a
    for j=Np+1:Np+4
        if x_extent(i,j)>Degree_violation(j-Np)+constraints(j-Np)
            x_extent(i,b+1)=1;
        end
    end
end

id=find(x_extent(:,b+1)==0);
Fea=x_extent(id,:);
Fea=sortrows(Fea,b+2);
id=find(x_extent(:,b+1)==1);
inFea=x_extent(id,:);
inFea=sortrows(inFea,b+2);
Rank=[Fea;inFea];
Rank=Rank(:,1:b);
end




