module top_module(
	input [8:0]SEin,
	output [63:0] SEout
    );assign SEout = {{55{SEin[8]}}, SEin};

endmodule