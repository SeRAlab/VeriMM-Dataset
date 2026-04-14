module top_module(
	input clk,
	input shift_en,
	input [7:0] data_in,
	output reg [7:0] data_out);always @(posedge clk) begin
		if (shift_en) 
			data_out <= {1'b0, data_out[7:1]};
		else 
			data_out <= data_in;
	end
	
endmodule