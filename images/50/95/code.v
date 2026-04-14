module top_module(D, C, E, Q);input D, C, E;
output reg Q;
always @(posedge C) begin
	if (!E) Q <= D;
end
endmodule