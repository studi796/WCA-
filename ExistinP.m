function [output,id]=ExistinP(input)
global P_Total;
global Np;
id=0;
    row_b = size(P_Total,1);
    output = 0;
    for i = 1:row_b
        if P_Total(i,1:Np) == input(1:Np)
            output = 1;
            id=i;
            break;
        end
    end
