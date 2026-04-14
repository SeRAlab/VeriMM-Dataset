module top_module(input IN0, IN1, IN2, output OUT);parameter [7:0] INIT = 0;
	assign OUT = INIT[{IN2, IN1, IN0}];
endmodule