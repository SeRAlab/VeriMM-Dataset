module register_with_enable (
	input clk,
	input reset,
	input enable,
	input [7:0] data_in,
	output reg [7:0] data_out);

	always @(posedge clk) begin
		if (reset)
			data_out <= 8'b00000000;
		else if (enable)
			data_out <= data_in;
	end
	
endmodule