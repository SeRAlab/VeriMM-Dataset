module and_64bit (out, a, b);
   input [63:0] a, b;
   output [63:0] out;
   
   assign out = a & b;
   
endmodule