module top_module(in,out,clk,reset);input [7:0]in;
  input clk,reset;
  output wire[7:0]out;
  
  wire [2:0]count;
  wire [2:0]run;
  reg [1:0]zero;


  assign out = in ? in : 0;
  assign run = in ? 0  : count;
  assign count = in ? 0 : count ? 3'b010 : 3'b001;
  
  
  
  
  
endmodule