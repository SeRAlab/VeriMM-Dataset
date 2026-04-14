module top_module(E, R, D, Q);input E, R, D;
output reg Q;
always @* begin
	if (R == 1)
                Q <= 1;
	else if (E == 1)
		Q <= D;
end
endmodule