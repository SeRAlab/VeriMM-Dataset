module top_module(a, b, sum, diff);parameter WIDTH = 8;
   input [WIDTH-1:0] a, b;
   output [WIDTH-1:0] sum, diff;
   
   assign sum = a + b;
   assign diff = a - b;
endmodule