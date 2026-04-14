module top_module(
   
   out, 
   
   in
   );input [33:0] in;
   output 	out;

   assign  out = (^in[33:0]);

endmodule