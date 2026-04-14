module mux2to1 (
	input sel,
	input d0,
	input d1,
	output y
);assign y = sel ? d1 : d0;

endmodule