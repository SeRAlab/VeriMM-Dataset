module top_module(
    input [10:0] IR,
    input [15:0] Ra,
    input [15:0] PC,
    input selEAB1,
    input [1:0] selEAB2,
    output [15:0] eabOut
    );wire [15:0] opA, opB;
	 
	 assign opA = (selEAB2 == 2'b00) ? (16'b0000000000000000) :
							(selEAB2 == 2'b01) ? {{10{IR[5]}} , IR[5:0]} :
							(selEAB2 == 2'b10) ? {{7{IR[8]}} , IR[8:0]} :
														{{6{IR[10]}} , IR[10:0]};
							
	 assign opB = selEAB1 == 1'b0 ? PC : Ra;
	 
	 assign eabOut = (opA + opB);

endmodule