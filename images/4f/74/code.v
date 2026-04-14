module top_module(D, C, L, AD, E, Q);input D, C, L, AD, E;
output reg Q;
always @(posedge C or posedge L) begin
	if (L == 1)
		Q <= AD;
	else if (E == 1)
		Q <= D;
end
endmodule