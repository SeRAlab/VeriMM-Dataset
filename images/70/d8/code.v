module top_module(inA, inB, outX, outY);input inA, inB;
	output outX, outY;
	assign outX = ~(inA & outY);
	assign outY = ~(inB & outX);
endmodule