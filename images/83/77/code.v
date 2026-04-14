module shift_register (CLK, RST, LOAD, IN, SI, OUT);
input CLK, RST, LOAD, SI;
input [7:0] IN;
output reg [7:0] OUT;

always @(posedge CLK or posedge RST) begin
	if (RST) begin
		OUT <= 8'b00000000;
	end
	else if (LOAD) begin
		OUT <= IN;
	end
	else begin
		OUT <= {OUT[6:0], SI};
	end
end

endmodule