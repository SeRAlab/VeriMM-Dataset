module top_module(output reg [27:0] result, input [25:0] in);always @(in)
  
  result = in << 2;endmodule