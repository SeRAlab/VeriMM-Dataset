module top_module(a, b, sum, diff, prod);input [7:0] a, b;
   output [7:0] sum, diff, prod;

   assign sum = a + b;
   assign diff = a - b;
   assign prod = a * b;

endmodule