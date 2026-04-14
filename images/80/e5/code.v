module top_module(a, out);input [3:0] a;
	output [3:0] out;
	
	assign out[0] = ~a[0];
	assign out[1] = ~a[1];
	assign out[2] = ~a[2];
	assign out[3] = ~a[3];
endmodule