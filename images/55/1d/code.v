module top_module(inA, inB, add_out);input [31:0] inA, inB;
	output [31:0] add_out;
	assign add_out=inA+inB;endmodule