module left_shift_32(input [31:0] data_in, output [31:0] result);

	assign result = {data_in[30:0], 1'b0};

endmodule