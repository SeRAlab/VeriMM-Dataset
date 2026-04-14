module mux2to1 (
	input sel,
	input a, b,
	output y);assign y = (sel == 1'b0) ? a :
	           (sel == 1'b1) ? b : 1'b0;

endmodule