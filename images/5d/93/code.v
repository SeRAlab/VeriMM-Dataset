module top_module(input signed [31:0] in1, input signed [31:0] in2, input [3:0] opCode, input [4:0] shiftAmt, output signed [31:0] result);assign result = opCode == 0 ? in1 + in2 :
			opCode == 1 ? in1 - in2 :
			opCode == 2 ? in1 & in2 :
			opCode == 3 ? in1 | in2 :
			opCode == 4 ? in1 << shiftAmt :
			opCode == 5 ? in1 >> shiftAmt :
			opCode == 6 ? in1 >>> shiftAmt :
			opCode == 7 ? in1 > in2 ? 1 : 0 :
			opCode == 8 ? in1 < in2 ? 1 : 0 : 0;

endmodule