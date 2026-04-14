module top_module(In, ShiftType, ShiftAmount, Out);input  [31:0] In;
	input  ShiftType;
	input  [4:0]ShiftAmount;
	output [31:0] Out;
	
	assign Out = (ShiftType == 1'b1) ? (In >> ShiftAmount) : (In << ShiftAmount);

endmodule