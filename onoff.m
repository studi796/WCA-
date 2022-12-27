function [onoff_data]=onoff(A)
  D_on=switchs2(A);
  D_off=switchs2([0,A(2:8)]);
  onoff_data=[D_on(1:2),-D_off(4)];
