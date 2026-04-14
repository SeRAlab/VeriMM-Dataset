module top_module(input clock,input reset,input strobe,input iqSel,input signed [11:0] sig_in,output signed [11:0] dcoffset,output signed [11:0] sigout);reg signed [25:0] integrator[1:0]; 
  assign dcoffset = integrator[iqSel][25:14]; 
  assign sigout = sig_in - dcoffset; 
  wire signed [25:0] update = integrator[iqSel] + {{(14){sigout[11]}},sigout}; 
  always @(negedge clock) 
  begin 
  if(reset) 
  begin 
  integrator[0] <= #1 26'd0; 
  integrator[1] <= #1 26'd0; 
  end 
  else if(strobe) 
  integrator[iqSel] <= #1 update; 
  end 
 endmodule