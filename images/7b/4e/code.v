module top_module(D, C, R, E, Q);input D, C, R, E;
output reg Q;
always @(posedge C or posedge R) begin
	if (R == 1)
		Q <= 1;
	else if (E == 1)
		Q <= D;
end
endmodule