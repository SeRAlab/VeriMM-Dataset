module circuit_module (
	input o,
	input p,
	output reg [3:0] mux_in);assign mux_in[0] = o & p;
	assign mux_in[1] = ~o | p;
	assign mux_in[2] = o & ~p;
	assign mux_in[3] = ~o & ~p;
	
endmodule