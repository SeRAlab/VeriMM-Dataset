module top_module(in,out,write);input [15:0]in; 
 input write; 
 output reg [15:0] out; 
 always @(*) 
 begin 
 if(write == 1'b0) 
  out = in; 
  else 
  out = out; 
  end 
  endmodule