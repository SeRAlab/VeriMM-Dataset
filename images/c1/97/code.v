module alu_mux_2(
	sel1,
	in1,
	in0,
	out
);
input wire	sel1;
input wire	in1;
input wire	in0;
output wire	out;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
assign	SYNTHESIZED_WIRE_2 = in0 & SYNTHESIZED_WIRE_0;
assign	SYNTHESIZED_WIRE_1 = in1 & sel1;
assign	out = SYNTHESIZED_WIRE_1 | SYNTHESIZED_WIRE_2;
assign	SYNTHESIZED_WIRE_0 =  ~sel1;
endmodule