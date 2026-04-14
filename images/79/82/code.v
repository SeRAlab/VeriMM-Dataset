module top_module(
	input wire [15:0] instr,
	output wire [31:0] SignImm
);assign SignImm [15:0] = instr;
	assign SignImm [31:16] = {16{instr[15]}};
endmodule