module bin_counter (CLK, RST, COUNT);
input CLK, RST;
output reg [3:0] COUNT;

always @(posedge CLK or posedge RST) begin
	if (RST) begin
		COUNT <= 4'b0000;
	end else begin
		if (COUNT == 4'b1111)
			COUNT <= 4'b0000;
		else
			COUNT <= COUNT + 1;
	end
end

endmodule