module alu_mux_4(
	in0,
	in1,
	in2,
	in3,
	sel,
	out
);
input wire	in0;
input wire	in1;
input wire	in2;
input wire	in3;
input wire	[1:0] sel;
output wire	out;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_9;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
assign	SYNTHESIZED_WIRE_4 = SYNTHESIZED_WIRE_8 & SYNTHESIZED_WIRE_9 & in0;
assign	SYNTHESIZED_WIRE_7 = sel[0] & SYNTHESIZED_WIRE_9 & in1;
assign	SYNTHESIZED_WIRE_5 = SYNTHESIZED_WIRE_8 & sel[1] & in2;
assign	SYNTHESIZED_WIRE_6 = sel[0] & sel[1] & in3;
assign	out = SYNTHESIZED_WIRE_4 | SYNTHESIZED_WIRE_5 | SYNTHESIZED_WIRE_6 | SYNTHESIZED_WIRE_7;
assign	SYNTHESIZED_WIRE_8 =  ~sel[0];
assign	SYNTHESIZED_WIRE_9 =  ~sel[1];
endmodule