module top_module (
	input clk,
	input load,
	input [3:0] pdata,
	output reg sdata);

	reg [3:0] shift_reg;

	always @(posedge clk) begin
		if (load)
			shift_reg <= pdata;
		else
			shift_reg <= {1'b0, shift_reg[3:1]};
		sdata <= shift_reg[0];
	end
endmodule