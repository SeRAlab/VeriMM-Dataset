module counter3(
	input wire clk,
	input wire rst,
	input wire en,
	output reg [2:0] Q
);always @(posedge clk or posedge rst) begin
	if (rst)
		Q <= 3'b000;
	else if (en)
		Q <= Q + 1;
end
endmodule