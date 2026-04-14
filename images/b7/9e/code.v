module top_module(output F, input I0, I1, I2, I3);parameter [15:0] INIT = 0;
	specify
		(I0 => F) = (1054, 1486);
		(I1 => F) = (1053, 1583);
		(I2 => F) = (867, 1184);
		(I3 => F) = (555, 902);
	endspecify	
	wire [ 7: 0] s3 = I3 ? INIT[15: 8] : INIT[ 7: 0];
	wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
	wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
	assign F = I0 ? s1[1] : s1[0];
endmodule