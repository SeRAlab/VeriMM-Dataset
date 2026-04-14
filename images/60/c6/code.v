module d_flip_flop (CLK, D, RST, Q);
input CLK, D, RST;
output reg Q;

always @(posedge CLK) begin
	if (RST)
		Q <= 1'b0;
	else
		Q <= D;
end

endmodule