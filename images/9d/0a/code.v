module shift_register (
	input clk,
	input rst,
	input load,
	input [7:0] data_in,
	output reg [7:0] reg_out);always @(posedge clk) begin
		if (rst)
			reg_out <= 8'b00000000;
		else if (load)
			reg_out <= data_in;
		else
			reg_out <= {reg_out[6:0], 1'b0};
	end
	
endmodule