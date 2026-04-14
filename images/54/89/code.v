module top_module(
		input wire	[7:0] opcode,
		input wire	[15:0] flags,
		output reg	[4:0] op_decoder_out
	);always @(*) begin
		case(opcode)
			8'h00:	op_decoder_out = 5'b01010;
			8'h01:	op_decoder_out = 5'b01000;
			8'h02:	op_decoder_out = 5'b00100;
			8'h03:	op_decoder_out = 5'b01110;
			8'h04:	op_decoder_out = flags[9] ? 5'b01110 : 5'b01111;
			8'h05:	op_decoder_out = 5'b10110;
			8'h06:	op_decoder_out = 5'b11010;
			8'h07:	op_decoder_out = 5'b11110;
			8'h08:	op_decoder_out = 5'b10010;
			8'h09:	op_decoder_out = flags[9] ? 5'b01111 : 5'b01110;
			8'h0a:	op_decoder_out = flags[10] ? 5'b01110 : 5'b01111;
			8'h0b:	op_decoder_out = 5'b10011;
			8'h0d:	op_decoder_out = 5'b10101;
			8'h0e:	op_decoder_out = 5'b10100;
			8'h70:	op_decoder_out = flags[8] ? 5'b01110 : 5'b01111;
			8'h71:	op_decoder_out = flags[9] ? 5'b01110 : 5'b01111;
			8'h72:	op_decoder_out = 5'b01000;
			8'h73:	op_decoder_out = 5'b01001;
			8'h74:	op_decoder_out = 5'b01010;
			8'h75:	op_decoder_out = 5'b10111;
			8'h7e:	op_decoder_out = 5'b00010;
			8'h7f:	op_decoder_out = 5'b00011;
			default:	op_decoder_out = 5'b00001;
		endcase
	end
endmodule