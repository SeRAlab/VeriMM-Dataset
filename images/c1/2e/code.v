module sparc_ifu_cmp35(
   hit, 
   a, b, valid
   );
   input [34:0] a, b;
   input 	valid;
   output 	hit;
   reg 		hit;
   wire 	valid;
   wire [34:0] 	a, b;
   always @ (a or b or valid)
     begin
	if ((a==b) & valid)
	  hit = 1'b1;
	else
	  hit = 1'b0;
     end 
endmodule