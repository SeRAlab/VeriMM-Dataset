module alu_slice(
	op2,
	op1,
	cy_in,
	R,
	S,
	V,
	cy_out,
	result
);
input wire	op2;
input wire	op1;
input wire	cy_in;
input wire	R;
input wire	S;
input wire	V;
output wire	cy_out;
output wire	result;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
assign	SYNTHESIZED_WIRE_0 = op2 | cy_in | op1;
assign	SYNTHESIZED_WIRE_3 = SYNTHESIZED_WIRE_0 & SYNTHESIZED_WIRE_1;
assign	SYNTHESIZED_WIRE_4 = cy_in & op2 & op1;
assign	result =  ~SYNTHESIZED_WIRE_2;
assign	SYNTHESIZED_WIRE_2 = ~(SYNTHESIZED_WIRE_3 | SYNTHESIZED_WIRE_4);
assign	SYNTHESIZED_WIRE_5 = op2 | op1;
assign	SYNTHESIZED_WIRE_7 = cy_in & SYNTHESIZED_WIRE_5;
assign	SYNTHESIZED_WIRE_8 = op1 & op2;
assign	cy_out = ~(R | SYNTHESIZED_WIRE_10);
assign	SYNTHESIZED_WIRE_10 = ~(SYNTHESIZED_WIRE_7 | SYNTHESIZED_WIRE_8 | S);
assign	SYNTHESIZED_WIRE_1 = V | SYNTHESIZED_WIRE_10;
endmodule