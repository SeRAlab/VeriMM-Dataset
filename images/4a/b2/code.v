module top_module(
	input  wire clk,

	input  wire re,
	input  wire [8:0] rdaddr,
	output reg  [7:0] dataout,

	input  wire we,
	input  wire [8:0] wraddr,
	input  wire [7:0] datain
);reg [7:0] mem[0:511]; 



	always @(posedge clk)
	if( re )
		dataout <= mem[rdaddr];

	always @(posedge clk)
	if( we )
		mem[wraddr] <= datain;

endmodule