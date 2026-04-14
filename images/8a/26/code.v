module top_module( 
  input         clock, 
  input         reset, 
  input  [31:0] io_input, 
  output [7:0]  io_output 
);wire [31:0] _T_10; 
  assign _T_10 = io_input >> 5'h10; 
  assign io_output = _T_10[7:0]; 
endmodule