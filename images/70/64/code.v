module top_module(
input[15:0] op_x,
input[15:0] op_y,
input[1:0] op_en,
output reg[15:0] op_out
    );always@(*)
	begin
		case(op_en)
			2'b00:op_out<=(op_x & op_y);
			2'b01:op_out<=(op_x | op_y);
			2'b10:op_out<=(~op_x);
			2'b11:op_out<=(op_x ^ op_y);
			default:
				op_out<=16'b0;
		endcase
	end

endmodule