module reg_unit #(parameter ff_sz=8)
	(	output reg[ff_sz-1:0] data_out,
		input [ff_sz-1:0] data_in,
		input load,
		input clk, rst);

	always @(posedge clk or negedge rst)
		if (~rst)
			data_out <= 0;
		else if (load)
			data_out <= data_in;
endmodule