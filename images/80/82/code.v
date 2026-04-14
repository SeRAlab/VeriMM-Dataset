module shift_register(CLK, RST, LOAD, D, Q);
input CLK, RST, LOAD;
input [7:0] D;
output [7:0] Q;
reg [7:0] Q;

always@(posedge CLK or posedge RST) begin
	if (RST)
		Q <= 0;
	else if (LOAD)
		Q <= D;
	else
		Q <= {1'b0, Q[7:1]};
end

endmodule