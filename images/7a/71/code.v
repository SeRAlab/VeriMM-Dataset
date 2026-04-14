module top_module(
	output [47:0] str,
	input [11:0] imm12
);wire [11:0] imm = imm12[11] ? -$signed(imm12) : imm12;

	wire [3:0] d0 = imm[3:0];
	wire [3:0] d1 = imm[7:4];
	wire [3:0] d2 = imm[11:8];

	wire [7:0] d0_s = d0 <= 9 ? "0" + d0 : "A" + d0 - 10;
	wire [7:0] d1_s = d1 <= 9 ? "0" + d1 : "A" + d1 - 10;
	wire [7:0] d2_s = d2 <= 9 ? "0" + d2 : "A" + d2 - 10;

	assign str = {imm12[11] ? "-" : " ", "0x", d2_s, d1_s, d0_s}; 

endmodule