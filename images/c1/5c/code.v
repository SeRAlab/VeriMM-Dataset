module sparc_ifu_par32 (
   out, 
   in
   );
   input [31:0] in;
   output 	out;
   assign  out = (^in[31:0]);
endmodule