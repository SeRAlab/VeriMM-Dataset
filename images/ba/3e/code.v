module top_module(D, C, E, Q);input D, C, E;
output reg Q;
always @(negedge C) begin
	if (E) Q <= D;
end
endmodule