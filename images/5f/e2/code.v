module signal_module (
	input u,
	input v,
	output reg [3:0] mux_signals);assign mux_signals[0] = u | ~v;
	assign mux_signals[1] = u & v;
	assign mux_signals[2] = u | ~v;
	assign mux_signals[3] = u & v;
	
endmodule