function [Y] = zdt2(x)
%   This procedure implements zdt2 function.
%   The canonical zdt2 function is defined as below --
%   f_1 = x_1
%   f_2 = g * (1.0 - (f_1/g)^2)
%   g(x_2, x_3, ..., x_n) = 1.0 + (9/(n - 1)) sum_{i = 2}^n x_i
%   0 <= x_i <= 1.0 (i = 1, 2, 3, ..., n)
global Np ;

% Y(1:Np)=x;

%Girewank函数
%输入x，得出y
Y(2)=sum(x.^2);
Y(3)=sum(sin(x));
% Y(3)=sum(x.^2-10*cos(2*pi*x)+10);
  %Y(2)=-20*exp(-0.2*sqrt((1/Np)*sum(x.^2)))-exp((1/Np)*sum(cos(2*pi.*x)))+exp(1)+20;
% S=0;
% for i=1:Np-1
%     S=S+100*(x(i)^2-x(i+1))^2+(x(i)-1)^2;
% end
% Y(1)=S;
 Y(1)=sum(x.^3);
end



