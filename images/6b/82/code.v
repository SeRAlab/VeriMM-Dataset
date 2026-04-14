module top_module(address, writeData, readDataMem, memWrite, memRead, clk);parameter DATA_BITS = 32;
	parameter ADDR_BITS = 32;

	
	input [(ADDR_BITS-1):0] address; 
	input [(DATA_BITS-1):0] writeData; 
	input memWrite;
	input memRead;
	input clk;
	output reg [(DATA_BITS-1):0] readDataMem; 

	
	reg [(DATA_BITS-1):0] data_RAM [(2**ADDR_BITS)-1:0];

	
	
	always @ * begin
		readDataMem <= data_RAM[address];
		end
		
	always@ (posedge clk) begin
			if (memWrite) begin
				data_RAM[address] <= writeData;
				readDataMem <= writeData;
			end
			
			else begin
				readDataMem <= data_RAM[address];
			end
		end
	

endmodule