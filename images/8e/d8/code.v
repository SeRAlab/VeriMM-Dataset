module top_module(
	input wire [31:0] A,
	input wire [31:0] B,
	input wire [2:0] optr,
	output wire [31:0] ret,
	output wire zero
);assign ret = (optr == 3'b000) ? A + B :
					(optr == 3'b100) ? A - B :
					(optr == 3'b001) ? A & B :
					(optr == 3'b101) ? A | B :
					(optr == 3'b010) ? A ^ B :
					(optr == 3'b110) ? {B[15],16'h0} : 0;
	
	assign zero = ~|ret;

endmodule