module top_module(output F, input I0);parameter [1:0] INIT = 0;
	specify
		(I0 => F) = (555, 902);
	endspecify
	assign F = I0 ? INIT[1] : INIT[0];
endmodule