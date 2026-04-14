module top_module(WritePort, R1, WRITEPORTSELECT);output	[4:0] WritePort;
input 	[4:0] R1;
input 			WRITEPORTSELECT;

assign WritePort = (WRITEPORTSELECT) ? 'b11111:R1;

endmodule