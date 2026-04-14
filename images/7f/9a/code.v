module top_module(S3, S2, S1, S0, C0, N2, N1);input S0, S1, S2, S3, C0;
	output [3:0] N2;
	output [3:0] N1;
	
	reg [3:0] N2;
	reg [3:0] N1;
	
	always @(C0, S3, S2, S1, S0) begin
		N2[3] = 1'b0;
		N2[2] = 1'b0;
		N2[1] = (C0 & S2) | (C0 & S3);
		N2[0] = (~C0 & S3 & S1) | (~C0 & S3 & S2) | (S3 & S2 & S1) | (C0 & ~S3 & ~S2);
		N1[3] = (~C0 & S3 & ~S2 & ~S1) | (C0 & ~S3 & ~S2 & S1) | (C0 & S3 & S2 & ~S1);
		N1[2] = (~C0 & ~S3 & S2) | (~C0 & S2 & S1) | (C0 & ~S2 & ~S1) | (C0 & S3 & ~S2);
		N1[1] = (~C0 & ~S3 & S1) | (~S3 & S2 & S1) | (~C0 & S3 & S2 & ~S1) | (C0 & ~S3 & ~S2 & ~S1) | (C0 & S3 & ~S2 & S1);
		N1[0] = S0;
	end
endmodule