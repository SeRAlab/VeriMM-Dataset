module control_module (
	input w,
	input x,
	output reg [3:0] mux_result);assign mux_result[0] = ~(w & x);
	assign mux_result[1] = w & ~x;
	assign mux_result[2] = ~(w & x);
	assign mux_result[3] = w & ~x;
	
endmodule