module left_shift (
   input [15:0] in,
   output [15:0] out
   );

   assign out = {in[2:0], 13'b0};

endmodule