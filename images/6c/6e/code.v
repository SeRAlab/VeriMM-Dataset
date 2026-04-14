module top_module(a,b,c,d,ctrl,f);input [1:0]ctrl;
	input f;
	output reg a,b,c,d;
	always @(ctrl or a or b or c or d)
		case(ctrl)
			2'b00: a=f;
			2'b01: b=f;
			2'b10: c=f;
			2'b11: d=f;
		endcase
endmodule