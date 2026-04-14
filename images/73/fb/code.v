module top_module( 
  input        clock, 
  input        reset, 
  input  [3:0] io_in_a, 
  input  [3:0] io_in_b, 
  input  [3:0] io_in_c, 
  output [7:0] io_out 
);wire [7:0] _T_13; 
  wire [7:0] _GEN_0; 
  wire [8:0] _T_14; 
  assign _T_13 = io_in_a * io_in_b; 
  assign _GEN_0 = {{4'd0}, io_in_c}; 
  assign _T_14 = _T_13 + _GEN_0; 
  assign io_out = _T_13 + _GEN_0; 
endmodule