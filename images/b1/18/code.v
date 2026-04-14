module top_module(						
		o_left,
		o_right,
		i_double_fig);output	[3:0]	o_left		;
output	[3:0]	o_right		;

input	[6:0]	i_double_fig	;

assign		o_left	= i_double_fig / 10	;
assign		o_right	= i_double_fig % 10	;endmodule