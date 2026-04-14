module top_module(D, C, Q);input D, C;
output reg Q;
always @(negedge C) begin
	Q <= D;
end
endmodule