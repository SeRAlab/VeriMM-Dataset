module top_module(sum, carry_out, wireA, wireB, carry_in);input [3:0] wireA;
   input [3:0] wireB;
   input carry_in;
   output [3:0] sum;
   output carry_out;

   assign {carry_out, sum} = wireA + wireB + carry_in;
endmodule