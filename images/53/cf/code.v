module top_module(result, arg1, arg2);input [7:0] arg1, arg2;
   output [7:0] result;

   assign result = arg1 + arg2;
   
endmodule