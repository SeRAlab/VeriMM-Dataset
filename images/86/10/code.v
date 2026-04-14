module top_module(out, in0, s0, in1, s1, in2, s2, in3, s3, in4, s4,
						in5, s5, in6, s6);parameter bits = 32;	
output [bits-1:0] out;
input [bits-1:0] in0, in1, in2, in3, in4, in5, in6;
input s0, s1, s2, s3, s4, s5, s6;

	reg [bits-1:0] out;

	always @ (s0 or s1 or s2 or s3 or s4 or s5 or s6
		or in0 or in1 or in2 or in3 or in4 or in5 or in6) begin
		case ({s6, s5, s4, s3, s2, s1, s0})	
			7'b0000001:	out = in0;
			7'b0000010:	out = in1;
			7'b0000100:	out = in2;
			7'b0001000:	out = in3;
			7'b0010000:	out = in4;
			7'b0100000:	out = in5;
			7'b1000000:	out = in6;
			
			default:	out = 65'hx;
			
		endcase
	end
endmodule