module up_down_counter (
	input clk,
	input rst,
	input up_down,
	output reg [3:0] count
);

	always @(posedge clk) begin
		if (rst) begin
			count <= 4'd0;
		end else if (up_down) begin
			count <= count + 1;
		end else begin
			count <= count - 1;
		end
	end
endmodule