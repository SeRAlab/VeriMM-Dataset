module top_module(output [N-1:0]out, input [N-1:0]x1, input [N-1:0]x2, input alpha);parameter N=32;
  
  assign #2 out = ((~alpha) ? x1 : x2);

endmodule