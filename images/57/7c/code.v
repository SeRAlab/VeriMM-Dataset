module t_flip_flop(
	input 	clk,
	input 	rst,
	input 	T,
	output reg Q
);

always @(posedge clk or posedge rst)
begin
	if (rst)
		Q <= 1'b0;
	else if (T)
		Q <= ~Q;
end

endmodule