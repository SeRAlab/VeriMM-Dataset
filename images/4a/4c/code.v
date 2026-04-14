module config_module (
	input o,
	input p,
	output reg [3:0] mux_vals);assign mux_vals[0] = o | ~p;
	assign mux_vals[1] = o & p;
	assign mux_vals[2] = o | ~p;
	assign mux_vals[3] = o & p;
	
endmodule