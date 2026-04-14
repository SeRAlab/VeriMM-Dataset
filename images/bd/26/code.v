module top_module(
	input [5:0]A,
	output B
	);wire [1:0]a,b;
	assign b=2'b01;
		
	`define this 0
	assign B=b[`this];
	`define this 1
endmodule