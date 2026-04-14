module top_module (
	input [3:0] a,
	input en,
	output [3:0] b);assign b = en ? ~a + 1 : 4'b0000;
	
endmodule