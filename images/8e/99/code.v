module top_module_2 (
	input c,
	input d,
	output reg [3:0] mux_in);assign mux_in[0] = c & d;
	assign mux_in[1] = ~c | d;
	assign mux_in[2] = c & ~d;
	assign mux_in[3] = ~c & ~d;
	
endmodule