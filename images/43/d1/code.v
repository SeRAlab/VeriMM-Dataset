module top_module(
	input wire sel,
	input wire [4:0] a,
	input wire [4:0] b,
	input wire [4:0] c,
	input wire [4:0] d,
	output reg [4:0] o
);always @(*)
	case(sel)
		2'b00: o<=a;
		2'b01: o<=b;
		2'b10: o<=c;
		2'b11: o<=d;
	endcase

endmodule