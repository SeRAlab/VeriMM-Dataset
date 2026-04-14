module top_module(
input [1:0] mode,
output reg [6:0] HEX3,HEX2,HEX1,HEX0
);always @(*)
begin
	if (mode == 2'b11)
		begin
			HEX3 = 7'b0010010;
			HEX2 = 7'b1111001;
			HEX1 = 7'b1001000;
			HEX0 = 7'b0000110;
		end
	else if (mode == 2'b00)
		begin
			HEX3 = 7'b0010010;
			HEX2 = 7'b1000000;
			HEX1 = 7'b1000001;
			HEX0 = 7'b0001000;
		end
	else
		begin
			HEX3 = 7'b0010010;
			HEX2 = 7'b1000000;
			HEX1 = 7'b1001000;
			HEX0 = 7'b1000010;
		end
end
endmodule