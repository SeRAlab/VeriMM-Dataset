module up_down_counter(CLK,RST,UP,DOWN,COUNT);
input CLK,RST,UP,DOWN;
output [2:0] COUNT;
reg [2:0] COUNT;

always@(posedge CLK or posedge RST) begin
	if (RST)
		COUNT <= 0;
	else if (UP && !DOWN)
		COUNT <= COUNT + 1;
	else if (!UP && DOWN)
		COUNT <= COUNT - 1;
	else
		COUNT <= COUNT;
end

endmodule