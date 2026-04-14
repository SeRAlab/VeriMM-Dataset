module top_module(out, in0, in1, in2, in3, select);output out;
input in0, in1, in2, in3;
input [1:0] select;

	reg out;

	always @ (select or in0 or in1 or in2 or in3) begin
		case (select)	
			2'b00:		out = in0;
			2'b01:		out = in1;
			2'b10:		out = in2;
			2'b11:		out = in3;
			
			default:	out = 1'hx;
			
		endcase
	end
endmodule