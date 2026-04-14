module top_module(input D, input Clock, output reg Q);always @(posedge Clock)
		Q = D;
endmodule