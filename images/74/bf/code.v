module top_module(CK, A, WE, OE, D, Q);input         CK;
input  [15:0] A;
input         WE;
input         OE;
input  [23:0] D;
output [23:0] Q;

reg    [15:0] latched_A;
reg    [23:0] memory [65535:0]; 

always @(posedge CK) begin
	if (WE) begin
		memory[A] <= D;
	end
		latched_A <= A;

end

assign Q = OE? memory[latched_A]:24'h0;

endmodule