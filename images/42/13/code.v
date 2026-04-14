module counter_up_down(
	input wire clk,
	input wire clear,
	input wire en,
	input wire up_down,
	output reg [7:0] Q
);always @(posedge clk) begin
	if (clear)
		Q <= 8'b00000000;
	else if (en) begin
		if (up_down)
			Q <= Q + 1;
		else
			Q <= Q - 1;
	end
end
endmodule