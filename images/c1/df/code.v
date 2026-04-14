module mux_node (
	input [1:0] in,
	input select,
	output out
);
assign out = select ?  in[1] : in[0];
endmodule