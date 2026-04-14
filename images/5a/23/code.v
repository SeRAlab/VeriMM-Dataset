module barrel_shifter_32bit (out, a, shift);
   input [31:0] a;
   input [4:0] shift;
   output [31:0] out;
   
   assign out = a << shift;
   
endmodule