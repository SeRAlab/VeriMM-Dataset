module d_flip_flop(
	input wire clk,
	input wire reset,
	input wire en,
	input wire D,
	output reg Q
);always @(posedge clk) begin
		if (reset)
			Q <= 1'b0;
		else if (en)
			Q <= D;
	end
endmodule