module top_module(
   output O, 
   input I0,
   input I1,
   input I2,
   input I3
);parameter LUTMASK = 16'h0000;

	wire [7:0] s3 = I3 ? LUTMASK[15:8] : LUTMASK[7:0];
	wire [3:0] s2 = I2 ?      s3[ 7:4] :      s3[3:0];
	wire [1:0] s1 = I1 ?      s2[ 3:2] :      s2[1:0];
	assign O = I0 ? s1[1] : s1[0];	   
endmodule