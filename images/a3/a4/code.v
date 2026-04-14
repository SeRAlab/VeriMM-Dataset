module logic_module (
	input r,
	input s,
	output reg [3:0] mux_in);assign mux_in[0] = ~r & s;
	assign mux_in[1] = r | s;
	assign mux_in[2] = r & ~s;
	assign mux_in[3] = r & s;
	
endmodule