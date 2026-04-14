module mux_module (
	input w,
	input z,
	output reg [3:0] mux_out);assign mux_out[0] = ~(w & z);
	assign mux_out[1] = w & ~z;
	assign mux_out[2] = ~(w & z);
	assign mux_out[3] = w & ~z;
	
endmodule