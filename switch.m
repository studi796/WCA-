clear all;
close all;

false=0;
true=1;
%addpath('D:\memscad\HFSS-MATLAB-API-master\3dmodeler');
%addpath('D:\memscad\HFSS-MATLAB-API-master\analysis');
%addpath('D:\memscad\HFSS-MATLAB-API-master\boundry');
%addpath('D:\memscad\HFSS-MATLAB-API-master\general');


tmpScriptFile = 'FILES\switch.vbs';
tmpDataFile='FILES\tmpData.m';
fid=fopen(tmpScriptFile,'wt');
hfssExepath='HFSS\AnsysEM18.2\Win64\ansysedt.exe';
Units = 'um';


h=1.4;
w=100;
le=120;
le1=50;
G=138;
G1=58;
t=0.1;
w1=100;

hfssaddVar(fid,'h',h,[]);
hfssaddVar(fid,'w',w,[]);
hfssaddVar(fid,'le',le,[]);
hfssaddVar(fid,'le1',le1,[]);
hfssaddVar(fid,'G',G1,[]);
hfssaddVar(fid,'G1',G1,[]);
hfssaddVar(fid,'t',t,[]);
hfssaddVar(fid,'w1',w1,[]);




hfssNewProject(fid);


%air
hfssBox(fid,'Air',[-200-le1,-500,-400],[400+2*le1,1000,800],'um');

%gallium_arsenide
hfssBox(fid,'GaAs',[-200-le1,-500,-400],[400+2*le1,1000,-100],'um');

%gold
hfssBox(fid,'Box2',[-200-le1,-w/2,0],[400+2*le1,w,2.3],'um');
hfssBox(fid,'Box2_sub',[-60,-w/2,0.3],[120,w,2.3],'um');
hfssSubtract(fid, {'Box2'}, {'Box2_sub'});
hfssBox(fid,'Box6',[-200-le1,w/2+G1,0],[400+2*le1,200,2.3],'um');
hfssBox(fid,'Box6_Dup',[-200-le1,-w/2-G1,0],[400+2*le1,-200,2.3],'um');
hfssBox(fid,'Box6_sub1',[-le,w/2+G,0],[2*le,G1-G,2.3],'um');

hfssBox(fid,'Box6_Dup_sub1',[-le,-w/2-G,0],[2*le,G-G1,2.3],'um');
hfssPolygon(fid, 'Box6_sub2_polygon', [-le,w/2+G,2.3;-le,w/2+G1,2.3;-200,w/2+G1,2.3], 'Line', true, 'um');
hfssPolygon(fid, 'Box6_sub2_polygon_Dup', [-le,-w/2-G,2.3;-le,w/2+G1,2.3;-200,w/2+G1,2.3], 'Line', true, 'um');
hfssSweepAlongVector(fid, 'Box6_sub2_polygon', [0,0,-2.3], 'um');
hfssSweepAlongVector(fid,'Box6_sub2_polygon_Dup',[0,0,-2.3],'um');
hfssDuplicateMirror(fid,{'Box6_sub2_polygon'},[1,0,0],'um');
hfssDuplicateMirror(fid,{'Box6_sub2_polygon_Dup'},[1,0,0],'um');
hfssBox(fid,'Box6_sub3',[le,w/2+G,0],[-40,200+G1-G,2],'um');
hfssBox(fid,'Box6_Dup_sub3',[le,-w/2+G,0],[-40,G-200-G1,2],'um');
hfssBox(fid,'Box_rightd',[-60,70,0],[120,w/2+g-90,0.3],'um');

hfssBox(fid,'bridge',[-w1/2,-w/2-G,h+0.3+t],[w1,w+2*G,2],'um');
hfssBox(fid,'hole_1',[-w1/2+10,-w/2-G+14,h+0.3+t],[(w1-60)/5,(w+2*G-216)/20,2],'um');
hfssBox(fid,'hole_2',[8-3*w1/10,-w/2-G+14,h+0.3+t],[(w1-60)/5,(w+2*G-216)/20,2],'um');
hfssBox(fid,'hole_3',[6-w1/10,-w/2-G+14,h+0.3+t],[(w1-60)/5,(w+2*G-216)/20,2],'um');
hfssBox(fid,'hole_4',[4+w1/10,-w/2-G+14,h+0.3+t],[(w1-60)/5,(w+2*G-216)/20,2],'um');
hfssBox(fid,'hole_5',[3*w1/10-2,-w/2-G+14,h+0.3+t],[(w1-60)/5,(w+2*G-216)/20,2],'um');
hfssDuplicateAlongLine(fid,{'hole_1;hole_2;hole_3;hole_4;hole_5'},[0,10+(w+2*G-216)/20,0],19,'um');
hfssSubstract(fid,{'bridge'},{'hole_1;hole_1_1;hole_1_2;hole_1_3;hole_1_4;hole_1_5;hole_1_6;hole_1_7;hole_1_8;hole_1_9;hole_1_10;hole_1_11;hole_1_12;hole_1_13;hole_1_14;hole_1_15;hole_1_16;hole_1_17;hole_1_18;hole_1_19;hole_2;hole_2_1;hole_2_2;hole_2_3;hole_2_4;hole_2_5;hole_2_6;hole_2_7;hole_2_8;hole_2_9;hole_2_10;hole_2_11;hole_2_12;hole_1_13;hole_1_14;hole_1_15;hole_1_16;hole_1_17;hole_1_18;hole_1_19;hole_3;hole_3_1;hole_3_2;hole_3_3;hole_3_4;hole_3_5;hole_3_6;hole_3_7;hole_3_8;hole_3_9;hole_3_10;hole_3_11;hole_3_12;hole_3_13;hole_3_14;hole_3_15;hole_3_16;hole_3_17;hole_3_18;hole_3_19;hole_4;hole_4_1;hole_4_2;hole_4_3;hole_4_4;hole_4_5;hole_4_6;hole_4_7;hole_4_8;hole_4_9;hole_4_10;hole_4_11;hole_4_12;hole_4_13;hole_4_14;hole_4_15;hole_4_16;hole_4_17;hole_4_18;hole_4_19;hole_5;hole_5_1;hole_5_2;hole_5_3;hole_5_4;hole_5_5;hole_5_6;hole_5_7;hole_5_8;hole_5_9;hole_5_10;hole_5_11;hole_5_12;hole_5_13;hole_5_14;hole_5_15;hole_5_16;hole_5_17;hole_5_18;hole_5_19;'})
hfssSubtract(fid, {'Box6'}, {'Box6_sub1'});
hfssSubtract(fid, {'Box6'}, {'Box6_sub2_polygon'});
hfssSubtract(fid, {'Box6'}, {'Box6_sub2_polygon_1'});
hfssSubstract(fid,{'Box6'},{'Box_sub3'});
hfssSubstract(fid,{'Box6_Dup'},{'Box6_Dup_sub1'});
hfssSubstract(fid,{'Box6_Dup'},{'Box6_sub2_polygon_Dup'});
hfssSubstract(fid,{'Box6_Dup'},{'Box6_sub2_polygon_Dup_1'});
hfssSubstract(fid,{'Box6_Dup'},{'Box6_Dup_sub3'});
hfssDuplicateMirror(fid,{'Box_rightd'},[0,-1,0],'um');


%siN
hfssBox(fid,'Box_rightu',[-60,70,0.3],[120,w/2+g-90,t],'um');
hfssDuplicateMirror(fid,{'Box_rightu'},[0,-1,0],'um');
hfssBox(fid,'Box_rightu',[-60,-w/2,0.3],[120,w,t],'um');

fclose(fid);
disp(tmpScriptFile)
disp('Script Completed');


