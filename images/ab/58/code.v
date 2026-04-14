module top_module(in, s, out);input wire[3: 0] in;
	input wire[1: 0] s;
	output wire out;
	reg _out;
	always @(in or s)
		case (s)
			2'b00: _out = in[0];
			2'b01: _out = in[1];
			2'b10: _out = in[2];
			2'b11: _out = in[3];
			default: _out = 1'b0;
		endcase
	assign out = _out;
endmodule