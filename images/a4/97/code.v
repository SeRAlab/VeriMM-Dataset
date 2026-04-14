module top_module( );reg 	      sel;
   reg [13:0] out;
   reg [13:0] a, b;




   always @(
	    sel or
	    a or
	    b
	   )
     begin
	out[13:0] = ( sel ? a[13:0] : b[13:0] );
     end
endmodule