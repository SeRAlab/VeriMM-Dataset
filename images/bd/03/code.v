module top_module( a, b, OF_detect, ALU_FUNC, out );input [2:0] ALU_FUNC;
input [15:0] a, b;
output reg [31:0] out;
output reg OF_detect;

always@(*)

case (ALU_FUNC)
	3'b000: begin
		out[15:0] = a + b;
		if( ( out[15:0] < a) || (out[15:0] < b) )
			OF_detect = 1;
		else begin
			OF_detect = 0;
			out[31:16] = 16'd0;
		end
		end
	3'b001: begin
		out[15:0] = a - b;
		if( out[15:0] > a )
			OF_detect = 1;
		else begin
			OF_detect = 0;
			out[31:16] = 16'd0;
		end
		end
	3'b100: begin
			out = a * b;
			OF_detect = 0;
		end
	3'b101: begin
			out[15:0] = a / b;
			out[31:16] = a % b;
			OF_detect = 0;
		end
	3'b010: begin
			out = a & b;
			OF_detect = 0;
		end
	3'b011: begin
			out = a | b;
			OF_detect = 0;
		end
endcase

endmodule