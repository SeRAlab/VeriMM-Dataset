module up_down_counter (CLK, RST, UP_DOWN, COUNT);
input CLK, RST, UP_DOWN;
output reg [2:0] COUNT;

always @(posedge CLK or posedge RST) begin
	if (RST)
		COUNT <= 3'b000;
	else if (UP_DOWN)
		COUNT <= COUNT + 1;
	else
		COUNT <= COUNT - 1;
end

endmodule