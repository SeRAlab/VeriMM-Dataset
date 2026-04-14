module top_module(
	dataIn0, dataIn1,
	dataOut0, dataOut1
);parameter DATA_SIZE = 8;	 
	 
input 		[DATA_SIZE - 1:0] dataIn0;
input 		[DATA_SIZE - 1:0] dataIn1;
output reg 	[DATA_SIZE - 1:0] dataOut0;
output reg 	[DATA_SIZE - 1:0] dataOut1;



always @(*) begin

	
	if(dataIn0 > dataIn1) begin
		dataOut0 = dataIn0;
		dataOut1 = dataIn1;
	end else begin
		dataOut0 = dataIn1;
		dataOut1 = dataIn0;
	end
end

endmodule