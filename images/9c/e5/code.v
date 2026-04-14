module sr_latch(
	input 	S,
	input 	R,
	output reg Q
);

always @(*)
begin
	if (S && R)
		Q <= 1'bx;
	else if (S)
		Q <= 1'b1;
	else if (R)
		Q <= 1'b0;
end

endmodule