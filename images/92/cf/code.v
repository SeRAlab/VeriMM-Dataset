module top_module(rst, clk, ie, de, iaddr, daddr, drw, din, iout, dout);input rst; 
  input clk; 
  input ie,de; 
  input [31:0] iaddr, daddr; 
  input [1:0] drw; 
  input [31:0] din; 
  output [31:0] iout, dout; 
  wire [31:0] idata, ddata; 
  assign iout = idata; 
  assign dout = ddata; 
  parameter cpu_id = 32'h00000401; 
  parameter board_freq = 32'h017d7840; 
  assign ddata = (daddr == 0) ? cpu_id : 
  (daddr == 4) ? board_freq : 0; 
 endmodule