module top_module(input [3:0]i,
input [1:0]sel,
output reg y);always @(i,sel)
begin
	case(sel)
		2'b00: y=i[0];
		2'b01: y=i[1];
		2'b10: y=i[2];
		2'b11: y=i[3];
	endcase
end

endmodule