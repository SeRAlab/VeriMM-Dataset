module top_module(
   input wire clk, 
	input wire en254r,
	input wire en254w,
	input wire [4:0] kbd,
	input wire ear,
	input wire d3,
	output wire [5:0] dout,
	output wire mic,
	output wire spk
	);reg ffmic;
	reg ffspk;
	reg [5:0] ear_y_teclado;
	
	assign dout = (!en254r)? ear_y_teclado : 6'bzzzzzz;
	assign mic = ffmic;
	assign spk = ffspk;
	
	always @(posedge clk)
		ear_y_teclado <= {ear,kbd};
	
	
	always @(posedge clk)
		if (!en254w)
			ffmic <= d3;

	
	always @(posedge clk)
		if (!en254r)
			ffspk <= 1;
		else if (!en254w)
			ffspk <= 0;
endmodule