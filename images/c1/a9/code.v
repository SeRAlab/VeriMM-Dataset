module alu_mux_2z(
	sel_a,
	sel_zero,
	a,
	ena,
	Q
);
input wire	sel_a;
input wire	sel_zero;
input wire	[3:0] a;
output wire	ena;
output wire	[3:0] Q;
wire	[3:0] SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
assign	SYNTHESIZED_WIRE_0 = a & {sel_a,sel_a,sel_a,sel_a};
assign	ena = sel_a | sel_zero;
assign	Q = SYNTHESIZED_WIRE_0 & {SYNTHESIZED_WIRE_1,SYNTHESIZED_WIRE_1,SYNTHESIZED_WIRE_1,SYNTHESIZED_WIRE_1};
assign	SYNTHESIZED_WIRE_1 =  ~sel_zero;
endmodule