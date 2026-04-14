module sparc_ifu_par34 (
   out, 
   in
   );
   input [33:0] in;
   output 	out;
   assign  out = (^in[33:0]);
endmodule