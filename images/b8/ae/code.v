module top_module(a, b);input [7:0] a; 
 output reg [7:0] b; // Changed 'output [7:0] b' to 'output reg [7:0] b' 
 always @(a) 
  begin 
  b = a; 
  end 
endmodule