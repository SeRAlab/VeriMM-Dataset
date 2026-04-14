module top_module(A,B);input [3:0]A;
	output reg[6:0]B;
	always @(*) begin
		case(A)
			 0: B<=7'b1000000;      		
			 1: B<=7'b1111001;      		
			 2: B<=7'b0100100;      		
			 3: B<=7'b0110000;      		
			 4: B<=7'b0011001;      		
			 5: B<=7'b0010010;      		
			 6: B<=7'b0000010;      		
			 7: B<=7'b1111000;      		
			 8: B<=7'b0000000; 				
			 9: B<=7'b0010000;				
			 
		
		default: B<=7'b1000000;				
			
	endcase
	end
endmodule