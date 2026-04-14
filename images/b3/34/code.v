module top_module(ORDER, BC, ADD, SUBC, EXT, REG, OUTPUT);input  [7:0] ORDER;
	input  [3:0] BC;
	input  [3:0] ADD;
	input  [3:0] SUBC;
	input  [3:0] EXT;
	input  [3:0] REG;
	output [3:0] OUTPUT;

	wire   [3:0] OUTPUT;

	assign OUTPUT = ORDER[7] ? (
		ORDER[6] ? REG : ORDER[5:2]
	) : (
		ORDER[6] ? (
			ORDER[5] ? (
				ORDER[4] ?
					(ORDER[3] ? REG : EXT)
				: SUBC
			) : ADD
		) : BC
	);

endmodule