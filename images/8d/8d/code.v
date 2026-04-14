module top_module(
	input clk,
	input up_down,
	input reset,
	output reg [1:0] count,
	output reg carry_out
);always @(posedge clk) begin
		if (reset) begin
			count <= 2'b0;
			carry_out <= 1'b0;
		end
		else begin
			if (up_down) begin
				if (count == 2'b11) begin
					count <= 2'b00;
					carry_out <= 1'b1;
				end
				else begin
					count <= count + 1;
					carry_out <= 1'b0;
				end
			end
			else begin
				if (count == 2'b00) begin
					count <= 2'b11;
					carry_out <= 1'b1;
				end
				else begin
					count <= count - 1;
					carry_out <= 1'b0;
				end
			end
		end
	end
	
endmodule