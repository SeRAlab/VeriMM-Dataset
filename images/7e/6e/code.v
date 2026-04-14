module top_module(
	
	gclk,
	WriteEnable,
	
	ReadAddr,
	WriteAddr,
	WriteData,
	ReadData
);input wire gclk;
	input wire WriteEnable;

	parameter WORD_WIDTH = 8;
	parameter ADDR_WIDTH = 8;
	`define RAM_DEPTH (1 << ADDR_WIDTH)
	
	input wire	[ ADDR_WIDTH-1:0 ] ReadAddr;
	input wire	[ ADDR_WIDTH-1:0 ] WriteAddr;
	input wire	[ WORD_WIDTH-1:0 ] WriteData;
	output reg	[ WORD_WIDTH-1:0 ] ReadData;
	
	reg [ ADDR_WIDTH-1:0 ] TempReadAddr;
	
	
	reg [ WORD_WIDTH-1:0 ] data [ 0:`RAM_DEPTH ];
	
	
	always @( posedge gclk ) begin
		
		
		ReadData <= data[ ReadAddr ];
		
		if (WriteEnable) data[ WriteAddr ] <= WriteData;
	end
	
	
	
endmodule