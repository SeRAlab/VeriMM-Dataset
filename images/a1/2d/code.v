module top_module(binary,hex);input [7:0] binary;
	output reg [6:0] hex;
	reg binary1;
	
	always@(*)
		begin
			case(binary)
				8'b0:
					hex=~(8'b0111111);
				8'd1:
					hex=~(8'b0000110);
				8'd2:
					hex=~(8'b1011011);
				8'd3:
					hex=~(8'b1001111);
				8'd4:
					hex=~(8'b1100110);
				8'd6:
					hex=~(8'b1111101);
				8'd7:
					hex=~(8'b0000111);
				8'd8:
					hex=~(8'b1111111);
				8'd9:
					hex=~(8'b1101111);
				default:
					hex=~(8'b1000000);
			endcase
					
		end
	
endmodule