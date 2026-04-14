module binary_down_counter(
	input clk,
	input rst_n,
	input en,
	output reg [7:0] count
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			count <= 8'b1111_1111;
		else if (en)
			count <= count - 1;
	end

endmodule