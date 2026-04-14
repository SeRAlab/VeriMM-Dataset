module top_module(
	input clk,
	input in,
	output reg out);reg [2:0] shift_reg;
			
	always @(posedge clk) begin
		shift_reg <= {shift_reg[1:0], in};
		out <= (shift_reg == 3'b111);
	end
	
endmodule