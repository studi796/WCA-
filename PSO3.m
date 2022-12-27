function y=PSO3(model,bu,bl,FES)
global  Np Ns w_ini w_end gmax c1 c2 w_ini2 w_end2 FESMAX M repeat;

 S=zeros(Ns,Np+M);
 bl=bl(1:Np);
  bu=bu(1:Np);
 S(1:Ns,1:Np)=sample([bl;bu]);
 for i=1:Ns
     [S(i,Np+3),s3,~]=predict(model,S(i,1:Np));
     S(i,Np+3)=S(i,Np+3)+(w_end2+(FESMAX-FES)*w_ini2/FESMAX+repeat(1,3))*s3;

 end
 [~,twc3]=max(S(:,Np+3));
 worst_on_S21=S(twc3,:);
 worsts_on_S21=S(1:Ns,:);

 Nt=size(S,1);
 v=rand(Nt,Np);
S_next=zeros(Ns,Np+3) ;
 for g=1:gmax
     w=(w_ini-w_end)*(gmax-g)/gmax+w_end;  
     for i=1:Ns
        v(i,:)=w*v(i,:)+c1*rand*(worst_on_S21(1,1:Np)-S(i,1:Np))+c2*rand*(worsts_on_S21(i,1:Np)-S(i,1:Np));   
     end
     for i=1:30
        S_next(i,1:Np)=round((S(i,1:Np)+v(i,:))*100)/100;
        for j=1:Np
            if S_next(i,j)>bu(j)
                S_next(i,j)=bu(j);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                
                elseif S_next(i,j)<bl(j)
                    S_next(i,j)=bl(j);
                  
            end
        end
        [S_next(i,Np+3),s3,~]=predict(model,S_next(i,1:Np));
        S_next(i,Np+3)=S_next(i,Np+3)+(w_end2+(FESMAX-FES)*w_ini2/FESMAX+repeat(1,3))*s3;

        if S_next(i,Np+3)>worst_on_S21(Np+3)
            worst_on_S21=S_next(i,:);
        end
        if S_next(i,Np+3)>worsts_on_S21(i,Np+3)
            worsts_on_S21(i,:)=S_next(i,:);
        end
     end
    S=S_next; 
 end
 y=[worst_on_S21];