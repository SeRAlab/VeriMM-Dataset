module binary_up_counter (
	input clk,
	input reset,
	input en,
	output reg [2:0] count,
	output reg carry);

	always @(posedge clk) begin
		if (reset) begin
			count <= 3'b000;
			carry <= 0;
		end
		else if (en) begin
			if (count == 3'b111) begin
				count <= 3'b000;
				carry <= 1;
			end
			else begin
				count <= count + 1;
				carry <= 0;
			end
		end
	end
endmodule