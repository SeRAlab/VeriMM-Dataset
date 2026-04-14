module t_flip_flop_sync_reset(
	input 	clk,
	input 	rst_n,
	input 	T,
	output reg Q
);

always @(posedge clk)
begin
	if (!rst_n)
		Q <= 1'b0;
	else if (T)
		Q <= ~Q;
end

endmodule