module top_module(clk, allow, in, out) ;parameter width = 1;  
  input clk, allow ;
  input [width-1:0] in ;
  output [width-1:0] out ;
  reg [width-1:0] out ;
  wire [width-1:0] toBeUpdated;

assign toBeUpdated = allow? in : out; 

  always @(posedge clk) 
    out = toBeUpdated ; 
endmodule