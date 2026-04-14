module top_module(seg7, s);input [1:0] s;
output [6:0] seg7;
assign seg7 = (s==2'b00)? 7'b010_0001:
				  (s==2'b01)? 7'b000_0110:
				  (s==2'b10)? 7'b100_0000:7'b011_1111;endmodule