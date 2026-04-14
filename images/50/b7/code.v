module top_module(clock, resetn, mantissa, exponent, sign, result, valid_in, valid_out, stall_in, stall_out, enable);input clock, resetn; 
  input [26:0] mantissa; 
  input [8:0] exponent; 
  input sign; 
  output [31:0] result; 
  input valid_in, stall_in, enable; 
  output valid_out, stall_out; 
  parameter FINITE_MATH_ONLY = 1; 
  assign valid_out = valid_in; 
  assign stall_out = stall_in; 
  generate 
  if (FINITE_MATH_ONLY == 0) 
  assign result = {sign, {8{exponent[8]}} | exponent[7:0], mantissa[25:3]}; 
  else 
  assign result = {sign, exponent[7:0], mantissa[25:3]}; 
  endgenerate 
 endmodule