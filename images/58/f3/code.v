module counter8bit_load_tc (
	input clk,
	input rst,
	input load,
	input [7:0] load_val,
	output reg [7:0] q,
	output tc);

	always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 8'b00000000;
		else if (load)
			q <= load_val;
		else
			q <= q + 1;
	end
	
	assign tc = (q == 8'b11111111) ? 1 : 0;
	
endmodule