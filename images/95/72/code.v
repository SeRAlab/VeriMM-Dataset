module johnson_counter_5bit(
	input clk,
	input rst_n,
	output reg [4:0] count
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			count <= 5'b00000;
		end
		else begin
			count <= {~count[0], count[4:1]};
		end
	end

endmodule