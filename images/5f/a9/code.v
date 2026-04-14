module top_module(/*AUTOARG*/
   // Outputs
   sum,
   // Inputs
   a
   );input [3:0] a;
   output [1:0] sum;
   
   assign sum = a[1:0] + 2'b0;
   
endmodule