module top_module(
	 input  [31:0] ReadData1,          
    input  [31:0] ReadData2,          
    output  EqualD,                   
	 output  LtzD                      
    );wire [31:0] result;
	 
	 assign result = ReadData1 - ReadData2;
	 
	 assign EqualD = (result == 32'h0000_0000) ? 1'b1 : 1'b0;
	 
	 assign LtzD = result[31];

endmodule