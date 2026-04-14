module binary_up_counter(
	input clk,
	input rst_n,
	input en,
	output reg [3:0] count
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			count <= 4'b0000;
		else if (en)
			count <= (count == 4'b1111) ? 4'b0000 : count + 1'b1;
	end

endmodule