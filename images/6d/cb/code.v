module top_module(w_bus_mux_out, w_bus_mux_in_0, w_bus_mux_in_1, w_channel);output [7:0] w_bus_mux_out;
	input [7:0] w_bus_mux_in_0, w_bus_mux_in_1;
	input w_channel;

	assign w_bus_mux_out = (w_channel) ? w_bus_mux_in_1 : w_bus_mux_in_0;
endmodule