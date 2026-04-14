module adder_32bit (a, b, sum);
   input [31:0] a, b;
   output [31:0] sum;
   
   assign sum = a + b;
endmodule