module kmap_implementation (
	input w,
	input x,
	output reg [3:0] mux_in);assign mux_in[0] = w & ~x;
	assign mux_in[1] = ~w | x;
	assign mux_in[2] = w & x;
	assign mux_in[3] = ~w & ~x;
	
endmodule