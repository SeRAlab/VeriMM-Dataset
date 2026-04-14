module barrel_shifter(
	input [3:0] d,
	input [1:0] s,
	output reg [3:0] q);always @(*)
	case (s)
		2'b00: q = d;
		2'b01: q = {d[2:0], d[3]};
		2'b10: q = {d[1:0], d[3:2]};
		2'b11: q = {d[0], d[3:1]};
	endcase
endmodule