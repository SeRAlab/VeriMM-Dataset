module updown_counter (CLK, RST, EN, UP, COUNT);
input CLK, RST, EN, UP;
output reg [1:0] COUNT;

always @(posedge CLK or posedge RST) begin
	if (RST) begin
		COUNT <= 2'b00;
	end
	else if (EN) begin
		if (UP) begin
			COUNT <= COUNT + 1;
		end
		else begin
			COUNT <= COUNT - 1;
		end
	end
end

endmodule