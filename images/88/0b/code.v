module top_module(Address, WriteData, MemRead, MemWrite, ReadData);input [6:0] Address; 
input [31:0] WriteData; 
input MemRead; 
input MemWrite; 
output reg [31:0] ReadData; 
reg [31:0] DataMemoryFile[6:0];

always @(*) begin
	if (MemRead)
		ReadData = DataMemoryFile[Address];
	if (MemWrite)
		DataMemoryFile[Address] = WriteData;
end

endmodule