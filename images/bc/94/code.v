module top_module(
		input zFlag,
		input carryFlag,
		input signFlag,
		input overflowFlag,
		input[2:0] brType,
		output brTrue
    );assign m1 = brType[0]?carryFlag:zFlag;
assign m2 = brType[0]?overflowFlag:signFlag;
assign mid = brType[1]?m2:m1;
assign brTrue = (brType[2]==mid)?1'b1:1'b0;



endmodule