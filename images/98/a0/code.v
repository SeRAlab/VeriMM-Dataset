module circular_shift_register (
	input clk,
	output [4:0] q);reg [4:0] shift_reg = 5'b00001;

	always @(posedge clk) begin
		shift_reg <= {shift_reg[3:0], shift_reg[4]};
	end
	
	assign q = shift_reg;
	
endmodule