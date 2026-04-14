module top_module(a,sel,y);input [3:0] a;
input [1:0] sel;
output reg y;

parameter A0 = 2'b00, A1 = 2'b01, A2 = 2'b10, A3 = 2'b11;

always@(*)	begin
			case(sel)
				
			A0: y = a[0];
			A1: y = a[1];
			A2: y = a[2];
			A3: y = a[3];
			
			endcase
		end
endmodule