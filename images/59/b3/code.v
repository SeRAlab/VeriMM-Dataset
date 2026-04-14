module top_module(D,Preset, Clock, Q);input D, Clock,Preset;
output reg Q;

always@(posedge Clock)
	Q = D;

endmodule