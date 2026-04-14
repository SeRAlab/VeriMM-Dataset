module top_module(
    input writeControl,
    input [7:0] inputData,
    output reg[7:0] outputData
    );always @(*)
		if(writeControl)	
		outputData=inputData;
endmodule