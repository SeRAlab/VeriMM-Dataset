module top_module(
clk,
reset,
data_in,
wen,
data_out,
avail_w1,
avail_w2,
ren_w1,
ren_w2,
count
);input clk;
  input reset;
  input [15:0] data_in;
  input ren_w1;
  input ren_w2;
  input wen;
  output reg avail_w1;
  output reg avail_w2;
  output reg [31:0] data_out;
   output reg [1:0] count;
   
   assign avail_w1 = 0;
   assign avail_w2 = 0;
   assign data_out = 0;
   assign count = 0;
  

endmodule