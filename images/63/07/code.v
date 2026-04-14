module up_down_counter_2bit(
	input clk,
	input rst_n,
	input up_down,
	output reg [1:0] count
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			count <= 2'b0;
		end
		else begin
			if (up_down) begin
				count <= count + 1;
			end
			else begin
				count <= count - 1;
			end
		end
	end

endmodule