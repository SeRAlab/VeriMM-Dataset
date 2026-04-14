module top_module(
	clk,
	trigger_reset,
	w5300_resetl
 );input clk;
	input trigger_reset;
	output w5300_resetl;

	reg [4:0] count = 5'h0;
	wire counting;

	assign w5300_resetl = ~counting;
	assign counting = ~(count == 5'h0);
	always @(posedge clk or posedge trigger_reset)
	begin
		if (trigger_reset) begin
			count = 5'h1;
		end
		else if (counting) begin
			count = count + 1;
		end
	end
endmodule