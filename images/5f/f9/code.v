module top_module(a, b, c, d, op, y);input [7:0] a;
input [7:0] b;
input [7:0] c;
input [7:0] d;
input [1:0] op;

output [7:0] y;

reg [7:0] y;

always @ (a or b or c or d or op )
begin
	

	case(op)
	2'b00 : y = a;
	2'b01 : y = b;
	2'b10 : y = c;
	default : y = d;
	endcase
		

	
end
endmodule