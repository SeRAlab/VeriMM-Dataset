module top_module(
input wire  [1:0] x,
input wire  enable,
output reg  [3:0] y 
);always  @(enable, x[1],x[0])
 
case(enable)
1:
	case(x)
	0:y = 4'b0000;
	1:y = 4'b0010;
	2:y = 4'b0100;
	3:y = 4'b1000;
	endcase
0: y=4'b0000;

endcase 
endmodule