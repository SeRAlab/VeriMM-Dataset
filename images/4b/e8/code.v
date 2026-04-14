module top_module(

		
		input clock,
		
		
		input[4:0] index1,
		
		
		output reg[31:0] readData1,
		
		
		input[4:0] index2,
		
		
		output reg[31:0] readData2,

		
		input[31:0] writeData2,
		
		
		input writeEnable2
		
	);reg[31:0] valueArray[0:31];

	
	always @(posedge clock) begin
		readData1 <= valueArray[index1];
		if (writeEnable2 == 0) begin
			readData2 <= valueArray[index2];
		end else begin
			readData2 <= writeData2;
			valueArray[index2] <= writeData2;
		end
	end

endmodule