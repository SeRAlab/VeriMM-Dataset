module sparc_tlu_penc64 (
   out, 
   in
   );
   input [63:0] in;
   output [5:0] out;
   reg [5:0] 	out;
   integer 	i;
always @ (in)
begin
	out = 6'b0;
	for (i=0;i<64;i=i+1)
	    begin
	       if (in[i])
		   out[5:0] = i[5:0];
	    end
end
endmodule