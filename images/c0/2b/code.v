module sparc_tlu_zcmp64(
   zero, 
   in
   );
   input [63:0] in;
   output      zero;
   reg 	       zero;
   always @ (in)
     begin
	if (in == 64'b0)
	  zero = 1'b1;
	else
	  zero = 1'b0;
     end
endmodule