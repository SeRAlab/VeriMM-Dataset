module top_module(s0,s1,s2,s3,in_0,in_1,in_2,in_3,in_4,in_5,in_6,in_7,in_8,in_9,in_a,in_b,in_c,in_d,in_e,in_f,out);input s0,s1,s2,s3;
input [31:0] in_0,in_1,in_2,in_3,in_4,in_5,in_6,in_7,in_8,in_9,in_a,in_b,in_c,in_d,in_e,in_f;
output reg [31:0] out;
	
always @(*) 
begin
	case({s3,s2,s1,s0})					
	4'b0000: out = in_0;
	4'b0001: out = in_1;
	4'b0010: out = in_2;
	4'b0011: out = in_3;
	4'b0100: out = in_4;
	4'b0101: out = in_5;
	4'b0110: out = in_6;
	4'b0111: out = in_7;
	4'b1000: out = in_8;
	4'b1001: out = in_9;
	4'b1010: out = in_a;
	4'b1011: out = in_b;
	4'b1100: out = in_c;
	4'b1101: out = in_d;
	4'b1110: out = in_e;
	4'b1111: out = in_f;
	default: out = 0;
	endcase
end
endmodule