module top_module(
	input [4:0] readReg1, readReg2,
	input [4:0] writeReg,
	input clk,
	input writeEnable,
	input [31:0] writeData,
	output [31:0] data1, data2
);reg [31:0] store [31:0];

	assign data1 = store[readReg1];
	assign data2 = store[readReg2];

	always@(posedge clk)
	begin
		if(writeEnable)
			store[writeReg] <= writeData;
	end

endmodule