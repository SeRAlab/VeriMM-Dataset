module alu_mux_3z(
	sel_zero,
	sel_a,
	sel_b,
	a,
	b,
	ena,
	Q
);
input wire	sel_zero;
input wire	sel_a;
input wire	sel_b;
input wire	[3:0] a;
input wire	[3:0] b;
output wire	ena;
output wire	[3:0] Q;
wire	[3:0] SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	[3:0] SYNTHESIZED_WIRE_2;
wire	[3:0] SYNTHESIZED_WIRE_3;
assign	SYNTHESIZED_WIRE_3 = a & {sel_a,sel_a,sel_a,sel_a};
assign	Q = SYNTHESIZED_WIRE_0 & {SYNTHESIZED_WIRE_1,SYNTHESIZED_WIRE_1,SYNTHESIZED_WIRE_1,SYNTHESIZED_WIRE_1};
assign	SYNTHESIZED_WIRE_1 =  ~sel_zero;
assign	SYNTHESIZED_WIRE_0 = SYNTHESIZED_WIRE_2 | SYNTHESIZED_WIRE_3;
assign	ena = sel_a | sel_b | sel_zero;
assign	SYNTHESIZED_WIRE_2 = b & {sel_b,sel_b,sel_b,sel_b};
endmodule