module down_counter_8bit(
	input clk,
	input rst,
	output reg [7:0] count
);

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			count <= 8'b11111111;
		end
		else begin
			count <= count - 1'b1;
		end
	end

endmodule