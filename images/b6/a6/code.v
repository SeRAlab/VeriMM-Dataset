module mux_logic (
	input i,
	input j,
	output reg [3:0] mux_in);assign mux_in[0] = ~i & j;
	assign mux_in[1] = i | j;
	assign mux_in[2] = ~i & ~j;
	assign mux_in[3] = i & ~j;
	
endmodule