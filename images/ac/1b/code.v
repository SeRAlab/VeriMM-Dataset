module register8(
	input wire clk,
	input wire set,
	input wire en,
	input wire [7:0] D,
	output reg [7:0] Q
);always @(posedge clk) begin
	if (set)
		Q <= 8'b11111111;
	else if (en)
		Q <= D;
end
endmodule