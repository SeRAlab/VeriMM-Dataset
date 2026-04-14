module top_module(inword, sel, outbyte);input [63:0] inword;
	input [2:0] sel;
	output reg [7:0] outbyte;
	
	always @(*) begin
		case(sel)
			3'h0:
				outbyte <= inword[7:0];
				
			3'h1:
				outbyte <= inword[15:8];
		
			3'h2:
				outbyte <= inword[23:16];
		
			3'h3:
				outbyte <= inword[31:24];
		
			3'h4:
				outbyte <= inword[39:32];
		
			3'h5:
				outbyte <= inword[47:40];
		
			3'h6:
				outbyte <= inword[55:48];
		
			3'h7:
				outbyte <= inword[63:56];
		
			default:
				outbyte <= 8'bxxxxxxxx;
		endcase
	end
endmodule