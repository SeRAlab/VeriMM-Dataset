module register(
	input wire clk,
	input wire reset,
	input wire en,
	input wire [7:0] D,
	output reg [7:0] Q
);always @(posedge clk or posedge reset) begin
	if (reset)
		Q <= 8'b0;
	else if (en)
		Q <= D;
end
endmodule