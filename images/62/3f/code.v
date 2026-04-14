module top_module (
	input clk,
	input reset,
	input [3:0] input_code,
	input [3:0] stored_code,
	output reg open);always @(posedge clk or posedge reset) begin
		if (reset) begin
			open <= 0;
		end else begin
			if (input_code == stored_code) begin
				open <= 1;
			end else begin
				open <= 0;
			end
		end
	end
	
endmodule