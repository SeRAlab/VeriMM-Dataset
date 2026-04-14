module top_module(rst, clk, ie, de, iaddr, daddr, drw, din, iout, dout, leds);input rst; 
  input clk; 
  input ie,de; 
  input [31:0] iaddr, daddr; 
  input [1:0] drw; 
  input [31:0] din; 
  output [31:0] iout, dout; 
  output reg [7:0] leds; 
  wire [31:0] idata, ddata; 
  assign iout = idata; 
  assign dout = ddata; 
  assign idata = 32'h00000000; 
  assign ddata = {24'h000000,leds}; 
  always @(negedge clk) begin 
  if (drw[0] && de && !rst) begin 
  leds = din[7:0]; 
  $display("MOD_LEDS: %x", din[7:0]); 
  end else if (rst) begin 
  leds = 8'hff; 
  end 
  end 
 endmodule