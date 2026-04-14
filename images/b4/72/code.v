module shift_reg (CLK, RST, LOAD, DATA_IN, SHIFT_IN, Q);
input CLK, RST, LOAD;
input [7:0] DATA_IN;
input SHIFT_IN;
output reg [7:0] Q;

always @(posedge CLK or posedge RST) begin
	if (RST)
		Q <= 8'b00000000;
	else if (LOAD)
		Q <= DATA_IN;
	else
		Q <= {Q[6:0], SHIFT_IN};
end

endmodule