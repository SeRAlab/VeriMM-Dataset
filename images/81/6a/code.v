module top_module(
input[8:0] deslocamento,
input[31:0] b,
input[13:0] imediate,
input[4:0] shift_desloc,
input[1:0] op_b,
output reg[31:0] b_select);parameter zero = 32'd0;
parameter extend5 = 27'd0;

always @(*)
begin
	case(op_b)
		2'b00:
			b_select <= b;
		2'b01:
			b_select <= $signed(deslocamento);
		2'b10:
			b_select <= $signed(imediate);
		2'b11:
			b_select <= {extend5,shift_desloc};
		default:
			b_select <= zero;
	endcase
end

endmodule