module top_module(D, C, L, AD, E, Q);input D, C, L, AD, E;
output reg Q;
always @(negedge C or negedge L) begin
	if (L == 0)
		Q <= AD;
	else if (E == 0)
		Q <= D;
end
endmodule