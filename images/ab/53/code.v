module register12(
	input wire clk,
	input wire set,
	input wire en,
	input wire [11:0] D,
	output reg [11:0] Q
);always @(posedge clk or posedge set) begin
	if (set)
		Q <= 12'b111111111111;
	else if (en)
		Q <= D;
end
endmodule