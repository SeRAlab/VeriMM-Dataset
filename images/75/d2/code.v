module top_module(data_in_16, data_out_32);input [15:0] data_in_16;
	output [31:0] data_out_32;
	
	assign data_out_32 = {{16{data_in_16[15]}}, data_in_16[15:0]};

endmodule