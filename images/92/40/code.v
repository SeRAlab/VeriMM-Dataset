module kmap_module (
	input w,
	input z,
	output reg [3:0] mux_in);assign mux_in[0] = w & ~z;
	assign mux_in[1] = ~w | z;
	assign mux_in[2] = ~w & z;
	assign mux_in[3] = w & z;
	
endmodule