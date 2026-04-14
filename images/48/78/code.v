module top_module(
	input a,
	input b,
	input c,
	input d,
	input [1:0] sel,
	output out);assign out = (sel == 2'b00) ? a :
			 (sel == 2'b01) ? b :
			 (sel == 2'b10) ? c : d;
endmodule