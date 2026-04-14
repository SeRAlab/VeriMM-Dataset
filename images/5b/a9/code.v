module Register_8bit (
	input clk,
	input rst_n,
	input clear,
	input [7:0] d,
	output reg [7:0] q
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			q <= 8'b00000000;
		end else if (clear) begin
			q <= 8'b00000000;
		end else begin
			q <= d;
		end
	end
endmodule