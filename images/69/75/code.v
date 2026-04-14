module d_flip_flop(
	input 	clk,
	input 	rst,
	input 	D,
	output reg Q
);

always @(posedge clk or posedge rst)
begin
	if (rst)
		Q <= 1'b0;
	else
		Q <= D;
end

endmodule