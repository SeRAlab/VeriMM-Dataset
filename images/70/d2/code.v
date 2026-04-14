module shift_register (
	input clk,
	input load,
	input [15:0] data_in,
	output reg [15:0] reg_out);
	
	always @(posedge clk) begin
		if (load)
			reg_out <= data_in;
		else
			reg_out <= {reg_out[14:0], 1'b0};
	end

endmodule