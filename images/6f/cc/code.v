module johnson_counter (
	input clk,
	output [2:0] q);reg [2:0] count_reg = 3'b000;

	always @(posedge clk) begin
		count_reg <= {~count_reg[2], count_reg[2:1]};
	end
	
	assign q = count_reg;
	
endmodule