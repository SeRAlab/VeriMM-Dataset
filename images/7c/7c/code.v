module top_module(out, in0, s0, in1, s1, in2, s2, in3, s3, in4, s4, in5, s5);parameter bits = 32;	
output [bits-1:0] out;
input [bits-1:0] in0, in1, in2, in3, in4, in5;
input s0, s1, s2, s3, s4, s5;

	reg [bits-1:0] out;

	always @ (s0 or s1 or s2 or s3 or s4 or s5
			or in0 or in1 or in2 or in3 or in4 or in5) begin
		case ({s5, s4, s3, s2, s1, s0})	
			6'b000001:	out = in0;
			6'b000010:	out = in1;
			6'b000100:	out = in2;
			6'b001000:	out = in3;
			6'b010000:	out = in4;
			6'b100000:	out = in5;
			
			default:	out = 65'hx;
			
		endcase
	end
endmodule