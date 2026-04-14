module sync_reset_register (
	input clk,
	input reset,
	input [7:0] data_in,
	output reg [7:0] data_out);

	always @(posedge clk) begin
		if (reset)
			data_out <= 8'b00000000;
		else
			data_out <= data_in;
	end
	
endmodule