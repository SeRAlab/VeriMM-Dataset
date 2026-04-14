module shift_register(
	input wire clk,
	input wire rst,
	input wire en,
	input wire [1:0] D,
	output reg [1:0] Q
);always @(posedge clk or posedge rst) begin
	if (rst)
		Q <= 2'b00;
	else if (en)
		Q <= {Q[0], D[0]};
end
endmodule