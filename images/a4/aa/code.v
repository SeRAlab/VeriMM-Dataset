module top_module(
	jze,
	jne,
	jcy,
	jov,
	jmp,
	bsr,
	ret,
	psr,
	ifu_jmp,
	ifu_bsr,
	ifu_ret
);input wire	jze;
input wire	jne;
input wire	jcy;
input wire	jov;
input wire	jmp;
input wire	bsr;
input wire	ret;
input wire	[31:0] psr;
output wire	ifu_jmp;
output wire	ifu_bsr;
output wire	ifu_ret;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;

assign	SYNTHESIZED_WIRE_4 = 0;



assign	SYNTHESIZED_WIRE_0 = jze & psr[30];


assign	SYNTHESIZED_WIRE_2 = jne & psr[31];

assign	SYNTHESIZED_WIRE_1 = jcy & psr[29];

assign	SYNTHESIZED_WIRE_3 = jov & psr[28];

assign	ifu_bsr = bsr;


assign	ifu_jmp = SYNTHESIZED_WIRE_0 | SYNTHESIZED_WIRE_1 | SYNTHESIZED_WIRE_2 | SYNTHESIZED_WIRE_3 | jmp | SYNTHESIZED_WIRE_4;

assign	ifu_ret = ret;



endmodule