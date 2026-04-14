module top_module(out, in0, in1, select);parameter bits = 32;	
output [bits-1:0] out;
input [bits-1:0] in0, in1;
input select;

	reg [bits-1:0] out;

	always @ (select or in0 or in1)
	case (select)	
		0: out = in0;
		1: out = in1;
		
		default: out = 65'bx ;
		
	endcase
endmodule