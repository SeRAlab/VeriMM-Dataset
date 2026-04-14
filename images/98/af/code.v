module top_module(
	input [2:0] aluop,
	input [31:0] instruction,
	output [3:0] op
	);wire [8:0] f;

	assign f[8] = instruction[29];
	assign f[7] = instruction[28];
	assign f[6] = instruction[27];
	assign f[5] = instruction[26];
	assign f[4] = instruction[25];
	assign f[1] = instruction[22];

	wire x,y,z;
	assign x = aluop[2];
	assign y = aluop[1];
	assign z = aluop[0];

	assign op[0] = (~x & y & ~z & f[8] & f[7] & ~f[6] & f[5] & f[4] & ~f[1]) | (~x & y & ~z & f[8] & f[7] & f[6] & ~f[5] & f[4] & ~f[1]) | (x & ~y & z);
	assign op[1] = (~x & ~y) | (~x & ~f[8] & ~f[7] & ~f[6] & f[5] & ~f[4] & ~f[1]) | (~x & f[8] & ~f[7] & ~f[6] & ~f[5] & ~f[4] & f[1]) | (~x & z);
	assign op[2] = (~x & ~y & z) | (~x & y & ~z & ~f[8] & ~f[7] & ~f[6] & f[5] & ~f[4] & ~f[1]) | (~x & y & ~z & f[8] & f[7] & f[6] & ~f[5] & f[4] & ~f[1]);
	assign op[3] = (~x & y & ~z & f[8] & f[7] & f[6] & ~f[5] & f[4] & ~f[1]);

endmodule