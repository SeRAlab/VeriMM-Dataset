module top_module(opA,opB_mux_out, clk, resetn, result);input [31:0] opA; 
 input [31:0] opB_mux_out; 
 input clk; 
 input resetn; 
 output[31:0] result; 
 reg [31:0] result; 
 always @ (posedge clk) 
 begin 
  if (resetn) 
  result <= 32'b00000000000000000000000000000000; 
  else 
  result <= opA * opB_mux_out; 
 end 
  endmodule