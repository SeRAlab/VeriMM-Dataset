module register10(
	input wire clk,
	input wire rst,
	input wire en,
	input wire [9:0] D,
	output reg [9:0] Q
);always @(posedge clk) begin
	if (rst)
		Q <= 10'b0000000000;
	else if (en)
		Q <= D;
end
endmodule