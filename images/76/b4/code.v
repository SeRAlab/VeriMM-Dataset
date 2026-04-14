module top_module(D, NC,Q);input D, NC;
output Q;
reg Q;

always @(NC or D)
	if (NC == 1'b0)
		Q <= D;


endmodule