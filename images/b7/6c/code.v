module core_module (
	input r,
	input s,
	output reg [3:0] mux_inputs);assign mux_inputs[0] = r | ~s;
	assign mux_inputs[1] = r & s;
	assign mux_inputs[2] = r | ~s;
	assign mux_inputs[3] = r & s;
	
endmodule