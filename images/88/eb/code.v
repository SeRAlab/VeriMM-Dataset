module shift_register9(
	input wire clk,
	input wire rst,
	input wire en,
	input wire [8:0] D,
	output reg [8:0] Q
);always @(posedge clk or posedge rst) begin
	if (rst)
		Q <= 9'b000000000;
	else if (en)
		Q <= {Q[7:0], D[0]};
end
endmodule