module register16(
	input wire clk,
	input wire clear,
	input wire en,
	input wire [15:0] D,
	output reg [15:0] Q
);always @(posedge clk) begin
	if (clear)
		Q <= 16'b0000000000000000;
	else if (en)
		Q <= D;
end
endmodule