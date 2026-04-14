module top_module(input clk,reset,IRWr,input [31:0] IMData,output reg [31:0] IR);always @(posedge clk)
 if(reset)
   IR<=0;
else
  if(IRWr)
    IR<=IMData;
 endmodule