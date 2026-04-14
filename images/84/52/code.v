module top_module(
	
	input clk,
	input rst,
		
	input memReadEX, memWriteEX,
		
	input memToRegEX,
	input regWriteEX,
		
	input [7:0] aluResEX,
	input [7:0] readData2EX,
	input [2:0] rdEX,
	
		
	output reg memReadEXOut, memWriteEXOut,
		
	output reg memToRegEXOut,
	output reg regWriteEXOut,
		
	output reg [7:0] aluResEXOut,
	output reg [7:0] readData2EXOut,
	output reg [2:0] rdEXOut
);always @(posedge clk or posedge rst) begin
		if(rst) begin
			memReadEXOut 	<= 1'b0;
			memWriteEXOut 	<= 1'b0;
			memToRegEXOut 	<= 1'b0;
			regWriteEXOut 	<= 1'b0;
			aluResEXOut 	<= 8'b0;
			readData2EXOut 	<= 8'b0;
			rdEXOut 		<= 3'b0;
		end
		else begin
			memReadEXOut 	<= memReadEX;
			memWriteEXOut 	<= memWriteEX;
			memToRegEXOut 	<= memToRegEX;
			regWriteEXOut 	<= regWriteEX;
			aluResEXOut 	<= aluResEX;
			readData2EXOut 	<= readData2EX;
			rdEXOut 		<= rdEX;
		end
	end

endmodule