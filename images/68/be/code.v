module top_module(output F, input I0, I1);parameter [3:0] INIT = 0;
	specify
		(I0 => F) = (867, 1184);
		(I1 => F) = (555, 902);
	endspecify
	wire [ 1: 0] s1 = I1 ? INIT[ 3: 2] : INIT[ 1: 0];
	assign F = I0 ? s1[1] : s1[0];
endmodule