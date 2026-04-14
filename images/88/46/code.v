module top_module(w_mux_out, w_mux_in_0, w_mux_in_1, w_mux_in_2, w_mux_in_3, w_enable);output [7:0] w_mux_out;
	input [7:0] w_mux_in_0, w_mux_in_1, w_mux_in_2, w_mux_in_3;
	input w_enable;

	assign w_mux_out = (w_enable) ? ((w_mux_in_3 << 24) | (w_mux_in_2 << 16) | (w_mux_in_1 << 8) | w_mux_in_0) : 8'b00000000;
endmodule