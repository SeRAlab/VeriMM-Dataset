module top_module(out,in7,in6,in5,in4,in3,in2,in1,in0,select);output [3:0] out;
	input [3:0] in7,in6,in5,in4,in3,in2,in1,in0;
	input [2:0] select;

	reg [3:0] out;

	always @(select or in7 or in6 or in5 or in4 or in3 or in2 or in1 or in0) begin
		case(select)	
			3'b111: out = in7;
			3'b110: out = in6;
			3'b101: out = in5;
			3'b100: out = in4;
			3'b011: out = in3;
			3'b010: out = in2;
			3'b001: out = in1;
			3'b000: out = in0;
			
			default: out = 65'hx;
			
		endcase
	end
endmodule