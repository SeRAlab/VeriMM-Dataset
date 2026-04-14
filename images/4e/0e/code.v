module top_module(input clock,input reset,input enable,input wire [15:0] i_in_ana,input wire [15:0] q_in_ana,input wire i_in_dig,input wire q_in_dig,output wire [15:0] i_out,output wire [15:0] q_out);assign i_out = (enable)?{i_in_ana[15:1],i_in_dig}:i_in_ana; 
  assign q_out = (enable)?{q_in_ana[15:1],q_in_dig}:q_in_ana; 
 endmodule