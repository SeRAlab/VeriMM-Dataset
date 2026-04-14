module top_module (
	input c,
	input d,
	output reg [3:0] mux_in);assign mux_in[0] = 1;
	assign mux_in[1] = ~c & d;
	assign mux_in[2] = 1;
	assign mux_in[3] = 1;
	
endmodule