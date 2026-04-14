module my_oddrx8(
input wire 			clk,
input wire [7:0] 	d0,
input wire [7:0] 	d1,
output reg [7:0]  io
);
always@(*)
begin
	case(clk)
	1'b0:io<=d1;
	1'b1:io<=d0;
	endcase
end
endmodule