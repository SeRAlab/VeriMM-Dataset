module ag_reg_decoder(keyb_in, shift, ctrl, keyb_out);
	input wire[6:0] keyb_in;
	input wire shift, ctrl;
	output wire[6:0] keyb_out;
	wire is_alpha = keyb_in[6] && !keyb_in[5];
	wire is_digit = !keyb_in[6] && keyb_in[5] && keyb_in[3:0];
	assign keyb_out =
		is_alpha?
			(shift?{1'b1,1'b1,keyb_in[4:0]}:
			 ctrl?{1'b0,1'b0,keyb_in[4:0]}:
			 keyb_in):
		is_digit?
			(shift?{1'b0,1'b1,~keyb_in[4],keyb_in[3:0]}:
			 keyb_in):
			 keyb_in;
endmodule