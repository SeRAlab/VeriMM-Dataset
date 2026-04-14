module adder_32bit (sum, carry_out, a, b);
   input [31:0] a, b;
   output [31:0] sum;
   output carry_out;
   
   assign {carry_out, sum} = a + b;
   
endmodule