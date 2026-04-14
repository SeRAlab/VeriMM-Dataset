module top_module(a, b, sel, f, ovf, zero);input signed [7:0] a, b;
	input [2:0] sel;
	output reg signed [7:0] f;
	output reg ovf;
	output reg zero;

	always@(a, b, sel) begin
		zero = 0;
		ovf = 0;
		f = 0;

		case(sel)
			3'b000: begin 
				f = a + b;
				ovf = ~(a[7] ^ b[7]) & (a[7] ^ f[7]);
			end
			3'b001: begin 
				f = ~b;
			end
			3'b010: begin 
				f = a & b;
			end
			3'b011: begin 
				f = a | b;
			end
			3'b100: begin 
				f = a >>> 1;
			end
			3'b101: begin 
				f = a <<< 1;
			end
			3'b110: begin 
				zero = a == b;
			end
			3'b111: begin 
				zero = a != b;
			end
			
		endcase
	end
endmodule