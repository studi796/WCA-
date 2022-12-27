function [d]=sample(m)

d=zeros(30,size(m,2));
samples=zeros(30,size(m,2));
for i=1:size(m,2)
    range1=[m(1,i)*3/4+m(2,i)/4,m(2,i)/2+m(1,i)/2];
    range2=[m(1,i)/2+m(2,i)/2,m(2,i)*3/4+m(1,i)/4];
    range3=[m(1,i)*9/10+m(2,i)/10,m(1,i)*3/4+m(2,i)/4];
    range4=[m(2,i)*3/4+m(1,i)/4,m(2,i)*9/10+m(1,i)/10];
    range5=[m(1,i)*19/20+m(2,i)/20,m(1,i)*9/10+m(2,i)/10];
    range6=[m(2,i)*9/10+m(1,i)/10,m(2,i)*19/20+m(1,i)/20];
    range7=[m(1,i)*49/50+m(2,i)/50,m(1,i)*19/20+m(2,i)/20];
    range8=[m(2,i)*19/20+m(1,i)/20,m(2,i)*49/50+m(1,i)/50];
    range9=[m(1,i)*99/100+m(2,i)/100,m(1,i)*49/50+m(2,i)/50];
    range10=[m(2,i)*49/50+m(1,i)/50,m(2,i)*99/100+m(1,i)/100];
    range11=[m(1,i),m(1,i)*99/100+m(2,i)/100];
    range12=[m(2,i)*99/100+m(1,i)/100,m(2,i)]; 
    samples(1,i)=range1(1)+rand(1)*(range1(2)-range1(1));
    samples(2,i)=range2(1)+rand(1)*(range2(2)-range2(1));
    samples(3,i)=range3(1)+rand(1)*(range3(2)-range3(1));
    samples(4,i)=range4(1)+rand(1)*(range4(2)-range4(1));
    samples(5,i)=range5(1)+rand(1)*(range5(2)-range5(1));
    samples(6,i)=range6(1)+rand(1)*(range6(2)-range6(1));
    samples(7,i)=range7(1)+rand(1)*(range7(2)-range7(1));
    samples(8,i)=range8(1)+rand(1)*(range8(2)-range8(1));
    samples(9,i)=range9(1)+rand(1)*(range9(2)-range9(1));
    samples(10,i)=range10(1)+rand(1)*(range10(2)-range10(1));
    samples(11,i)=range11(1)+rand(1)*(range11(2)-range11(1));
    samples(12,i)=range12(1)+rand(1)*(range12(2)-range12(1));
    samples(13,i)=range1(1)+rand(1)*(range1(2)-range1(1));
    samples(14,i)=range2(1)+rand(1)*(range2(2)-range2(1));
    samples(15,i)=range3(1)+rand(1)*(range3(2)-range3(1));
    samples(16,i)=range4(1)+rand(1)*(range4(2)-range4(1));
    samples(17,i)=range5(1)+rand(1)*(range5(2)-range5(1));
    samples(18,i)=range6(1)+rand(1)*(range6(2)-range6(1));
    samples(19,i)=range7(1)+rand(1)*(range7(2)-range7(1));
    samples(20,i)=range8(1)+rand(1)*(range8(2)-range8(1));
    samples(21,i)=range9(1)+rand(1)*(range9(2)-range9(1));
    samples(22,i)=range10(1)+rand(1)*(range10(2)-range10(1));
    samples(23,i)=range11(1)+rand(1)*(range11(2)-range11(1));
    samples(24,i)=range12(1)+rand(1)*(range12(2)-range12(1));
    samples(25,i)=range1(1)+rand(1)*(range1(2)-range1(1));
    samples(26,i)=range2(1)+rand(1)*(range2(2)-range2(1));
    samples(27,i)=range3(1)+rand(1)*(range3(2)-range3(1));
    samples(28,i)=range4(1)+rand(1)*(range4(2)-range4(1));
    samples(29,i)=range5(1)+rand(1)*(range5(2)-range5(1));
    samples(30,i)=range6(1)+rand(1)*(range6(2)-range6(1));
end
for j=1:size(m,2)
    r=randperm(30);
    d(:,j)=samples(r,j);
end
d=(round(d(:,:)*100))/100;