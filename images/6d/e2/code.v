module top_module(
	input clk,
	output [4:0] out);reg [4:0] ring_reg = 5'b00001;

	always @(posedge clk) begin
		ring_reg <= {ring_reg[0], ring_reg[4:1]};
	end

	assign out = ring_reg;

endmodule