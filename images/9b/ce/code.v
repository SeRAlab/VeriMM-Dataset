module top_module (
	input [7:0] data, 
	output reg parity);always @(*)
	parity = ^data;
		
endmodule