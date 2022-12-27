function [Result]=switchs2(DesignParameters)

tmpScriptFile = 'FILES\switch2.vbs';
tmpDataFile='FILES\tmpData2.m';
fid=fopen(tmpScriptFile,'wt');
hfssExepath='HFSS\AnsysEM18.2\Win64\ansysedt.exe';
hfssNewProject(fid);
hfssInsertDesign(fid, 'switch2');

% %parameters
% h=1.4;
% Ws=27;
% G=21;
% G1=15;
% Wb=20;
% Wh=8;
% Gh=12;
% Lb=125;
h=DesignParameters(1);
Ws=DesignParameters(2);
G=DesignParameters(3);
G1=DesignParameters(4);
Wb=DesignParameters(5);
Wh=DesignParameters(6);
Gh=DesignParameters(7);
Lb=DesignParameters(8);
LB=2*Lb+6*Wh+5*Gh;
%gallium_arsenide
hfssBox(fid,'gallium_arsenide','GaAs',[250,0,0],[-500,410,-100],'um');

%gold
hfssPolygon(fid, 'gold','Box5_1', [-Ws/2-G,0,0;-Ws/2-G,139,0;-Ws/2-G1,145,0], 'Line', 'true', 'um');
hfssPolygon(fid, 'gold','Box5_2', [-Ws/2-G1,145,0;-Ws/2-G1,260,0;-Ws/2-G,266,0], 'Line', 'true', 'um');
hfssPolygon(fid, 'gold','Box5_3', [-Ws/2-G,266,0;-Ws/2-G,410,0;-234.5,410,0], 'Line', 'true', 'um');
 hfssPolygon(fid, 'gold','Box5_4', [-234.5,410,0;-234.5,0,0;-Ws/2-G,0,0], 'Line', 'true', 'um');
hfssUnite(fid,'Box5_1','Box5_2');
 hfssUnite(fid,'Box5_1','Box5_3');
hfssUnite(fid,'Box5_1','Box5_4');
hfssCoverLines(fid,'Box5_1');
 hfssSweepAlongVector(fid, 'Box5_1', [0,0,2.4], 'um');
hfssDuplicateMirror(fid,{'Box5_1'},[1,0,0],'um');

hfssBox(fid,'gold','Box1',[-Ws/2,0,0],[Ws,140,2.4],'um');
hfssBox(fid,'gold','Box3',[-Wb/2,140,h+0.3],[Wb,LB,2],'um');
hfssBox(fid,'gold','Box3_sub1',[-Wh/2,140+Lb,h+0.3],[Wh,Wh,2],'um');
hfssBox(fid,'gold','Box3_sub2',[-Wh/2,140+Lb+Wh+Gh,h+0.3],[Wh,Wh,2],'um');
hfssBox(fid,'gold','Box3_sub3',[-Wh/2,140+Lb+2*Wh+2*Gh,h+0.3],[Wh,Wh,2],'um');
hfssBox(fid,'gold','Box3_sub4',[-Wh/2,140+Lb+3*Wh+3*Gh,h+0.3],[Wh,Wh,2],'um');
hfssBox(fid,'gold','Box3_sub5',[-Wh/2,140+Lb+4*Wh+4*Gh,h+0.3],[Wh,Wh,2],'um');
hfssBox(fid,'gold','Box3_sub6',[-Wh/2,140+Lb+5*Wh+5*Gh,h+0.3],[Wh,Wh,2],'um');
hfssSubtract(fid, {'Box3'}, {'Box3_sub1','Box3_sub2','Box3_sub3','Box3_sub4','Box3_sub5','Box3_sub6'});
%6Wh+5Gh>107
hfssBox(fid,'gold','Box6',[-Ws/2,LB+135,0],[Ws,15,0.3],'um');
hfssBox(fid,'gold','Box7',[-Ws/2,LB+150,0],[Ws,260-LB,2.4],'um');

%Vacuum
hfssBox(fid,'air','Air',[-250,0,-5000],[500,410,10000],'um');
hfssAssignRadiation(fid,'Rad','Air');

%waveport
 hfssRectangle(fid,'PortRec','Y',[-105,0,-200],400,210,'um');
%hfssCoverlines(fid,'PortRec');
 hfssSetTransparency(fid, {'PortRec'}, 0.91);
hfssDuplicateAlongLine(fid,{'PortRec'},[0,410,0],2,'um');
hfssSetTransparency(fid, {'PortRec_1'}, 0.91);
hfssAssignWavePort(fid,'Port1','PortRec',1,0,'um');
hfssAssignWavePort(fid,'Port2','PortRec_1',1,0,'um');
%Add a solution setup
hfssInsertSolution(fid,'Setup35GHz',35,0.02,6);
hfssInterpolatingSweep(fid,'Sweep30_40GHz','Setup35GHz',30,40,101);
hfssSolveSetup(fid,'Setup35GHz');
hfssExportNetworkData(fid,tmpDataFile,'Setup35GHz','Sweep30_40GHz');
fclose(fid);
disp('Solving using HFSS ..');
hfssExecuteScript(hfssExepath, tmpScriptFile);
run(tmpDataFile);
abs_S=abs(S(:,:,1));
S11_Max=20*log10(max(abs_S(:,1)));
S21_Max=-20*log10(min(abs_S(:,2)));
S11_Min=20*log10(min(abs_S(:,1)));
S21_Min=-20*log10(max(abs_S(:,2)));
%  

 Result=[S11_Max,S21_Max,S11_Min,S21_Min];
end





