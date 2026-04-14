module top_module(
	input wire [15:0] a,
	input wire mreq,
	input wire iorq,
	input wire rd,
	input wire wr,
	output wire romce,
	output wire ramce,
	output wire xramce,
	output wire vramdec,
	output wire en254r,
	output wire en254w
	);wire en254;
	
   
	assign romce = mreq | a[15] | a[14] | a[13] | rd;
	assign ramce = mreq | a[15] | a[14] | ~a[13] | ~a[12]; 
	assign xramce = mreq | a[15] | ~a[14];  
	assign vramdec = mreq | a[15] | a[14] | ~a[13] | a[12]; 
	assign en254 = iorq | a[0]; 
	assign en254r = en254 | rd;
	assign en254w = en254 | wr;
endmodule