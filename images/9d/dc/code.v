module binary_up_down_counter(
	input clk,
	input rst_n,
	input up,
	output reg [1:0] count
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			count <= 2'b00;
		else if (up)
			count <= count + 1;
		else
			count <= count - 1;
	end

endmodule