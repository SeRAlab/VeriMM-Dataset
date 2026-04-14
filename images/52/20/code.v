module binary_to_onehot (
	input [2:0] bin_in,
	output reg [7:0] onehot_out
);

always @* begin
	onehot_out = 8'b00000000;
	onehot_out[bin_in] = 1'b1;
end

endmodule