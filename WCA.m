function worst=WCA(A)
global Np;
global GPmodel1  GPmodel2 GPmodel3;
global M S;
global Fluc;
global P_Total;
global Ns w_ini w_end gmax c1 c2 w_ini2 w_end2 FESMAX Min Max;
Ns=30;
w_ini=0.9;%权重
w_end=0.4;
w_ini2=1;
w_end2=1;
gmax=200;%迭代次数
global repeat;
c1=1;%自我学习
c2=1;
M=3;
Max=A+Fluc(1,:);%取值范围
Min=A+Fluc(2,:);
Np=8;
S(1:30,1:Np)=sample([Min;Max]);

tic;
for i=0:1:(Ns-1)
     S(i+1,1:Np)=(round((Min+(Max-Min)*(i+rand(1))/Ns)*100))/100;        
end
  for j=1:1:Np
       r=randperm( Ns);
       S(:,j)=S(r,j);
  end
for i=1:Ns 
   fprintf('This is the solution %d of WCA\n',i);
   S(i,Np+1:Np+M)=zdt2(S(i,1:Np));
 end

disp(S);
[~,twc1]=max(S(:,Np+1));
worst_total(1,:)=S(twc1,:);
Worst_on_S11=worst_total(1,Np+1);
[~,twc2]=max(S(:,Np+2));
worst_total(2,:)=S(twc2,:);
Worst_on_S21=worst_total(2,Np+2);
[~,twc3]=max(S(:,Np+3));
worst_total(3,:)=S(twc3,:);
Worst_off_S21=worst_total(3,Np+3);

P_Total=S;
G=0;
L1=1;
L2=2;
L3=3;
flag=G;
FES=0;
results1=[];
results2=[];
results3=[];
Eip=zeros(1,3);
gap=zeros(3,3);
FES_NEW=0;
FESMAX=300;
fes=0;
repeat=zeros(1,3);
fess=[];

while FES<=FESMAX
    if flag==G
       GPmodel1=fitrgp(P_Total(:,1:Np),P_Total(:,Np+1),'KernelFunction','ardsquaredexponential');
       GPmodel2=fitrgp(P_Total(:,1:Np),P_Total(:,Np+2),'KernelFunction','ardsquaredexponential');
       GPmodel3=fitrgp(P_Total(:,1:Np),P_Total(:,Np+3),'KernelFunction','ardsquaredexponential');
       ratio=0.75*(FESMAX-FES)/FESMAX;
       a=rand;
       if a<ratio
           mode=0;
       else
           mode=1;
       end
       Search_result=PSO(GPmodel1,GPmodel2,GPmodel3,Max,Min,FES,mode);
 
       for m=1:3
         [Eips(1,m),id]=ExistinP(Search_result(m,1:Np));
         if Eips(1,m)==0
             Search_result(m,Np+1:Np+3)=zdt2(Search_result(m,1:Np));
             P_Total=[P_Total;Search_result(m,:)];
             repeat(1,m)=0;
             FES=FES+1;
         else
             FES=FES+1;
             Search_result(m,Np+1:Np+3)=P_Total(id,Np+1:Np+3);
             if mode==1
                 repeat(1,m)=repeat(1,m)+5;
             end
         end
         fess=[fess;FES];
         fes=fes+1;
         results1=[results1;Search_result(m,Np+1)];
         results2=[results2;Search_result(m,Np+2)];
         results3=[results3;Search_result(m,Np+3)];
         figure(2);
         plot(1:fes,results1);
         figure(3);
         plot(1:fes,results2);
         figure(4);
         plot(1:fes,results3);
         for n=1:3
            gap(m,n)=(Search_result(m,Np+n)-worst_total(n,Np+n))/abs(worst_total(n,Np+n));
         end
         if Search_result(m,Np+1)>worst_total(1,Np+1)
            worst_total(1,:)=Search_result(m,:);
         end
         if Search_result(m,Np+2)>worst_total(2,Np+2)
            worst_total(2,:)=Search_result(m,:);
         end
         if Search_result(m,Np+3)>worst_total(3,Np+3)
            worst_total(3,:)=Search_result(m,:);
         end
         Worst_on_S11=[Worst_on_S11;worst_total(1,Np+1)];
         Worst_on_S21=[Worst_on_S21;worst_total(2,Np+2)];
         Worst_off_S21=[Worst_off_S21;worst_total(3,Np+3)];
         figure(1);
         plot(1:FES+1,Worst_on_S11);
         figure(5);
         plot(1:FES+1,Worst_on_S21);
         figure(6);
         plot(1:FES+1,Worst_off_S21);
       end
       if Eips==[0,0,0]
             flag=G;      
       else
         [gapmax,gapmaxid]=max(gap);
         [linemax,lineinmax]=max(gapmax);
         next_para=Search_result(gapmaxid(lineinmax),:);
         if gapmax(lineinmax)>0
            flag=lineinmax;
         else
            flag=G;
         end
       end
    end
    
    if flag==L1
        if size(P_Total,1)<30
            S_Model=P_Total;
        else
            S_Model=Euclidean_NearTest(next_para,30,P_Total);
        end
        GPmodel1=fitrgp(S_Model(:,1:Np),S_Model(:,Np+flag));
        bu_U=max(S_Model);
        bu_L=min(S_Model);
        Search_result_L=PSO1(GPmodel1,bu_U,bu_L,fes);
        [Eip,id]=ExistinP(Search_result_L(1:Np));
        if Eip==0
        Search_result_L(Np+1:Np+3)=zdt2(Search_result_L(1:Np));
        repeat(1,1)=0;
        P_Total=[P_Total;Search_result_L]; 
        FES=FES+1;
        else
            Search_result_L(Np+1:Np+3)=P_Total(id,Np+1:Np+3);
            repeat(1,1)=repeat(1,1)+5;
        end
        fess=[fess;FES];
                fes=fes+1;
         for n=1:3
         gap(1,n)=(Search_result_L(Np+n)-worst_total(n,Np+n))/abs(worst_total(n,Np+n));
        if Search_result_L(Np+n)>worst_total(n,Np+n)
            worst_total(n,:)=Search_result_L;  
        end

        end
        [gapmax,gapmaxid]=max(gap(1,:));
         if gapmax>0
             flag=gapmaxid;
         else
             flag=G;
         end
         next_para=Search_result_L;
         results1=[results1;Search_result_L(Np+1)];
         results2=[results2;Search_result_L(Np+2)];
         results3=[results3;Search_result_L(Np+3)];
         figure(2);
         plot(1:fes,results1);
         figure(3);
         plot(1:fes,results2);
         figure(4);
         plot(1:fes,results3);
         Worst_on_S11=[Worst_on_S11;worst_total(1,Np+1)];
         Worst_on_S21=[Worst_on_S21;worst_total(2,Np+2)];
         Worst_off_S21=[Worst_off_S21;worst_total(3,Np+3)];   
         figure(1);
         plot(1:fes+1,Worst_on_S11);
         figure(5);
         plot(1:fes+1,Worst_on_S21);
         figure(6);
         plot(1:fes+1,Worst_off_S21);
         FES_NEW=FES_NEW+1;
    end
    
    if flag==L2
        if size(P_Total,1)<30
            S_Model=P_Total;
        else
            S_Model=Euclidean_NearTest(next_para,30,P_Total);
        end
        GPmodel2=fitrgp(S_Model(:,1:Np),S_Model(:,Np+flag));
        bu_U=max(S_Model);
        bu_L=min(S_Model);
        Search_result_L=PSO2(GPmodel2,bu_U,bu_L,fes);
        [Eip,id]=ExistinP(Search_result_L(1:Np));
        if Eip==0
        Search_result_L(Np+1:Np+3)=zdt2(Search_result_L(1:Np));
        FES=FES+1;
        P_Total=[P_Total;Search_result_L];   
        repeat(1,2)=0;
        else
            Search_result_L(Np+1:Np+3)=P_Total(id,Np+1:Np+3);
            repeat(1,2)=repeat(1,2)+5;
        end
        fess=[fess;FES];
        FES_NEW=FES_NEW+1;
        fes=fes+1;
        for n=1:3
            gap(1,n)=(Search_result_L(Np+n)-worst_total(n,Np+n))/abs(worst_total(n,Np+n));
            if Search_result_L(Np+n)>worst_total(n,Np+n)
                worst_total(n,:)=Search_result_L;  
            end
        end
        [gapmax,gapmaxid]=max(gap(1,:));
        if gapmax>0
             flag=gapmaxid;
         else
             flag=G;
         end

        next_para=Search_result_L;
        results1=[results1;Search_result_L(Np+1)];
        results2=[results2;Search_result_L(Np+2)];
        results3=[results3;Search_result_L(Np+3)];
        figure(2);
        plot(1:fes,results1);
        figure(3);
        plot(1:fes,results2);
        figure(4);
        plot(1:fes,results3);
        Worst_on_S11=[Worst_on_S11;worst_total(1,Np+1)];
        Worst_on_S21=[Worst_on_S21;worst_total(2,Np+2)];
        Worst_off_S21=[Worst_off_S21;worst_total(3,Np+3)];   
        figure(1);
        plot(1:fes+1,Worst_on_S11);
        figure(5);
        plot(1:fes+1,Worst_on_S21);
        figure(6);
        plot(1:fes+1,Worst_off_S21);
    end
    
    if flag==L3
        if size(P_Total,1)<30
            S_Model=P_Total;
        else
            S_Model=Euclidean_NearTest(next_para,30,P_Total);
        end
        GPmodel3=fitrgp(S_Model(:,1:Np),S_Model(:,Np+flag));
        bu_U=max(S_Model);
        bu_L=min(S_Model);
        Search_result_L=PSO3(GPmodel3,bu_U,bu_L,fes);
        [Eip,id]=ExistinP(Search_result_L(1:Np));
        if Eip==0
            FES=FES+1;
        Search_result_L(Np+1:Np+3)=zdt2(Search_result_L(1:Np));
        P_Total=[P_Total;Search_result_L]; 
        repeat(1,3)=0;
        else
            Search_result_L(Np+1:Np+3)=P_Total(id,Np+1:Np+3);
            repeat(1,3)=repeat(1,3)+5;
        end
        fess=[fess;FES];
        FES_NEW=FES_NEW+1;
                   fes=fes+1;
         for n=1:3
                     gap(1,n)=(Search_result_L(Np+n)-worst_total(n,Np+n))/abs(worst_total(n,Np+n));
        if Search_result_L(Np+n)>worst_total(n,Np+n)
            worst_total(n,:)=Search_result_L;  
        end
        end
        [gapmax,gapmaxid]=max(gap(1,:));
         if gapmax>0
             flag=gapmaxid;
         else
             flag=G;
         end

         next_para=Search_result_L;
        results1=[results1;Search_result_L(Np+1)];
        results2=[results2;Search_result_L(Np+2)];
        results3=[results3;Search_result_L(Np+3)];
        figure(2);
        plot(1:fes,results1);
        figure(3);
        plot(1:fes,results2);
        figure(4);
        plot(1:fes,results3);
        Worst_on_S11=[Worst_on_S11;worst_total(1,Np+1)];
        Worst_on_S21=[Worst_on_S21;worst_total(2,Np+2)];
        Worst_off_S21=[Worst_off_S21;worst_total(3,Np+3)];   
        figure(1);
        plot(1:fes+1,Worst_on_S11);
        figure(5);
        plot(1:fes+1,Worst_on_S21);
        figure(6);
        plot(1:fes+1,Worst_off_S21);
    end
    
disp(fes);
disp(fess);

end
worst=[A(1:Np),Worst_on_S11,Worst_on_S21,Worst_off_S21,1] ;
end

        
        
        
        
            
           
        
        
        
        
        
        