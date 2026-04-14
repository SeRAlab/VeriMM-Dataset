module register (
	input clk,
	input enable,
	input [15:0] data_in,
	output reg [15:0] data_out);always @(posedge clk) begin
		if (enable)
			data_out <= data_in;
	end
	
endmodule