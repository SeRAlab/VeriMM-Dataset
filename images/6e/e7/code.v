module top_module(
	input [15:0] instr,
	output [15:0] forced_instr
);wire z = 0;
assign forced_instr = {z, z, z, z, instr[11:0] };

endmodule