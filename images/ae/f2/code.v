module top_module (
	input [10:0] f,
	output [10:0] clear_middle,
	output [10:0] toggle_edges);assign clear_middle = {f[10:6], 1'b0, f[4:0]};
	assign toggle_edges = {~f[10], f[9:1], ~f[0]};
	
endmodule