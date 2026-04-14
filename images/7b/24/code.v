module shift_register(
	input 	clk,
	input 	rst,
	input 	load,
	input 	[3:0] D,
	output reg [3:0] Q
);

always @(posedge clk or posedge rst)
begin
	if (rst)
		Q <= 4'b0000;
	else if (load)
		Q <= D;
	else
		Q <= {Q[2:0], 1'b0};
end

endmodule