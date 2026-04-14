module top_module(
	input [7:0] instr_mul, instr_mulh, instr_mulhsu, instr_mulhu,
        output instr_any_mul
);assign instr_any_mul = |{instr_mul, instr_mulh, instr_mulhsu, instr_mulhu};
endmodule