module top_module(w_bus_mux_out, w_bus_mux_in_0, w_bus_mux_in_1, w_bus_mux_in_2, w_bus_mux_in_3, w_channel);output [1:0] w_bus_mux_out;
	input [1:0] w_bus_mux_in_0, w_bus_mux_in_1, w_bus_mux_in_2, w_bus_mux_in_3;
	input [1:0] w_channel;

	assign w_bus_mux_out = (w_channel == 2'b00) ? w_bus_mux_in_0 :
	                       (w_channel == 2'b01) ? w_bus_mux_in_1 :
	                       (w_channel == 2'b10) ? w_bus_mux_in_2 :
	                                             w_bus_mux_in_3;
endmodule