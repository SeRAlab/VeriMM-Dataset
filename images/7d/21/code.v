module top_module(
   
   out,
   
   in
   );input [31:0] in;
   output [31:0] out;

   genvar 	 i;
   generate
      for (i=0; i<16; i=i+1) begin : gblk
	 assign out[i*2+1:i*2] = in[(30-i*2)+1:(30-i*2)];
      end
   endgenerate
endmodule