module shift_reg_8bit(
	input clk,
	input load,
	input [7:0] data_in,
	input serial_in,
	output reg [7:0] q
);

	always @(posedge clk) begin
		if (load) begin
			q <= data_in;
		end else begin
			q <= {q[6:0], serial_in};
		end
	end
	
endmodule