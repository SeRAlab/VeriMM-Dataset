module top_module(
		imme, out
    );parameter IMME_SIZE = 16;
	parameter DATA_SIZE = 32;

	input wire [IMME_SIZE-1:0] imme;
	output wire [DATA_SIZE-1:0] out;

	assign out = {{(DATA_SIZE-IMME_SIZE){imme[IMME_SIZE-1]}}, imme};

endmodule