module top_module(D, C, L, AD, Q);input D, C, L, AD;
output reg Q;
always @(posedge C or posedge L) begin
	if (L == 1)
		Q <= AD;
	else
		Q <= D;
end
endmodule