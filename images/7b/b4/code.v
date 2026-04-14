module gray_counter (
	input clk,
	output [2:0] q);reg [2:0] gray_reg = 3'b000;
reg [2:0] binary_reg = 3'b000;

	always @(posedge clk) begin
		binary_reg <= binary_reg + 1;
		gray_reg <= {binary_reg[2], binary_reg[2] ^ binary_reg[1], binary_reg[1] ^ binary_reg[0]};
	end
	
	assign q = gray_reg;
	
endmodule