module top_module(
   
   out32, out10,
   
   in
   );input  [1:0] in;
   output [1:0] out32;
   output [1:0] out10;

   assign out32 = in[3:2];
   assign out10 = in[1:0];
endmodule