module top_module(x, out);input	[3:0]	x;
	output			out;
	reg			out;
	always @(*) begin
		case (x)
			3,6,9:	out = 1;	
			default:	out = 0;	
		endcase
	end	
endmodule