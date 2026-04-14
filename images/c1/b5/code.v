module ag6502_decimal(ADD, D_IN, NEG, CORR);
	input wire[4:0] ADD;
	input wire D_IN, NEG;
	output wire[4:0] CORR;
	wire C9 = {ADD[4]^NEG, ADD[3:0]} > 5'd9;
	assign CORR = D_IN?{C9^NEG, C9?ADD[3:0] + (NEG?4'd10:4'd6): ADD[3:0]}: ADD;
endmodule