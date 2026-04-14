module sparc_ifu_incr46(a, a_inc, ofl);
   input  [45:0]  a;
   output [45:0]  a_inc;
   output 	  ofl;
   reg [45:0] 	  a_inc;
   reg 		  ofl;
   always @ (a)
     begin
	      a_inc = a + (46'b1);
	      ofl = (~a[45]) & a_inc[45];
     end
endmodule