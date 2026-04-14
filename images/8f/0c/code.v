module top_module(select, inA, inB, outC);parameter k = 1;
	input         select;
	input  [k-1:0] inA;
	input  [k-1:0] inB;
	output [k-1:0] outC;

	assign outC = select ? inA : inB;endmodule