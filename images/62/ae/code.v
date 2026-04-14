module top_module(op, a, b, o);parameter WID = 32;
	input  [2:0] op;			
	input  [WID:1] a;			
	input  [WID:1] b;			
	output [WID:1] o;			
	reg    [WID:1] o;

	reg [WID:1] o1;
	wire inv = op[2];

	always @(a or b or op)
		case (op[1:0])
		2'd0:	o1 <= a^b;		
		2'd1:	o1 <= a&b;		
		2'd2:	o1 <= a|b;		
		2'd3:	o1 <= a&~b;		
		endcase

	always @(o1 or inv)
		case (inv)
		1'd0:	o <= o1;
		1'd1:	o <= ~o1;
		endcase

endmodule