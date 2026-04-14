module top_module(clock, address, writedata, dataout, out, MemoryWrite, reset);input clock, out, MemoryWrite, reset;
	input [4:0] address;
	input [31:0] writedata;
	output reg [31:0] dataout;
	reg [31:0] Memory [31:0];
	
	always @(posedge clock)
		begin
			Memory[0] = 32'b0;
			if (MemoryWrite)
				Memory[address] = writedata;
			else if (out)
				dataout = Memory[address];
			else if (reset)
				dataout = Memory[0];
		end
		
		
endmodule