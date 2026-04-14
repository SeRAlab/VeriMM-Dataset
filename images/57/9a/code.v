module top_module(
    input [4:0] ReadReg1,
    input [4:0] ReadReg2,
    input [4:0] WriteReg,
    input [31:0] WriteData,
    input RegWrite,
	 input clk,
    output [31:0] ReadData1,
    output [31:0] ReadData2
    );reg [31:0] RegisterBank [31:0];
	
	always @(posedge clk)
	begin
		if(RegWrite) 
			RegisterBank[WriteReg] <= WriteData;
	end
	
	assign ReadData1 = ( ReadReg1 == 0)? 32'b0 : RegisterBank[ReadReg1];  
	assign ReadData2 = ( ReadReg2 == 0)? 32'b0 : RegisterBank[ReadReg2];  

endmodule