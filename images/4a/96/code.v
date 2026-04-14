module top_module(clk, wrtEn, dataIn, dataOut);parameter BIT_WIDTH = 32;
	
	input clk, wrtEn;
	input[BIT_WIDTH - 1: 0] dataIn;
	output[BIT_WIDTH - 1: 0] dataOut;
	reg[BIT_WIDTH - 1: 0] dataOut = {(BIT_WIDTH){1'b0}};

	always @(negedge clk) begin
		if (wrtEn)
			dataOut <= dataIn;
	end
	
endmodule