module ring_counter (
	input clk,
	output [3:0] q);reg [3:0] count_reg = 4'b0001;

	always @(posedge clk) begin
		count_reg <= {count_reg[2:0], count_reg[3]};
	end
	
	assign q = count_reg;
	
endmodule