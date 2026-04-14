module top_module(
 input [15:0] d,
 input load,
 input reset,
 input clk,
 output [15:0] q
);reg[15:0] qi=0;
 
 always @(posedge clk or posedge reset)
 if(reset)
  qi<=0;
 else if(load)
   qi<=d;
 else
  qi<=qi;
  
 assign q=qi;endmodule