module top_module(input clock,input reset,input enable,input wire [15:0] i_in,input wire [15:0] q_in,output wire [15:0] i_out_ana,output wire [15:0] q_out_ana,output wire i_out_dig,output wire q_out_dig);assign i_out_ana = (enable)?{i_in[15:1],1'b0}:i_in; 
  assign q_out_ana = (enable)?{q_in[15:1],1'b0}:q_in; 
  assign i_out_dig = (enable)?i_in[0]:1'b0; 
  assign q_out_dig = (enable)?q_in[0]:1'b0; 
 endmodule