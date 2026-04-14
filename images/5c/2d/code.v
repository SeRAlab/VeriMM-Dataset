module logic_module (
	input k,
	input l,
	output reg [3:0] mux_outputs);assign mux_outputs[0] = ~(k & l);
	assign mux_outputs[1] = k & ~l;
	assign mux_outputs[2] = ~(k & l);
	assign mux_outputs[3] = k & ~l;
	
endmodule