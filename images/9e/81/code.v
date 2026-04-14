module top_module(
	input signed [31:0] a,
	input signed [31:0] b,
	input [2:0] ctrlInput,
	output zero,
	output reg [31:0] aluResult
);always @ * begin
	case(ctrlInput)
		0 : aluResult = a&b;
		1 : aluResult = a|b;
		2 : aluResult = a[31] ? -a : a;
		3 : aluResult = a+b;
		4 : aluResult = a-b;
		5 : aluResult = a+1;
		6 : aluResult = (a<b)? 31'd1 : 31'd0;
		7 : aluResult = a;
	endcase
end

assign zero = (aluResult == 0);

endmodule