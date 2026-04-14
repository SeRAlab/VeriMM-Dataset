module top_module(
  input  [15:0] io_i_input1,
  input  [15:0] io_i_input2,
  output [31:0] io_o_out
);wire [16:0] _T_11; 
  wire [15:0] _T_12; 
  assign _T_11 = io_i_input1 + io_i_input2; 
  assign _T_12 = io_i_input1 + io_i_input2; 
  assign io_o_out = {{16'd0}, _T_12}; 
endmodule