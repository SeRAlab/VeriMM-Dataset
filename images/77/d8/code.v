module sr_latch (
	input S,
	input R,
	output reg Q
);

always @(*)
begin
	if (S & R)
		Q <= 1'bx; // Invalid condition
	else if (S)
		Q <= 1;
	else if (R)
		Q <= 0;
end

endmodule