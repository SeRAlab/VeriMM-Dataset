module main_module (
	input w,
	input z,
	output reg [3:0] mux_input);assign mux_input[0] = w | ~z;
	assign mux_input[1] = w & z;
	assign mux_input[2] = w | ~z;
	assign mux_input[3] = w & z;
	
endmodule