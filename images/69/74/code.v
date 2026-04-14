module mux8bit2to1 (
	input sel,
	input [7:0] d0,
	input [7:0] d1,
	output [7:0] y
);assign y = (sel == 1'b0) ? d0 : d1;

endmodule