module top_module(C, S, R, E, D, Q);input C, S, R, E, D;
output reg Q;
always @(posedge C, posedge S, posedge R) begin
	if (R == 1)
		Q <= 0;
	else if (S == 1)
		Q <= 1;
        else if (E == 0)
		Q <= D;
end
endmodule