module top_module(x, hex);input [3:0] x;
	output reg [0:6] hex;
	
	always @(*)
	begin
		case (x)
		4'd0: hex = 7'b0000001;
		4'd1: hex = 7'b1001111;
		4'd2: hex = 7'b0010010;
		4'd3: hex = 7'b0000110;
		4'd4: hex = 7'b1001100;
		4'd5: hex = 7'b0100100;
		4'd6: hex = 7'b0100000;
		4'd7: hex = 7'b0001111;
		4'd8: hex = 7'b0000000;
		4'd9: hex = 7'b0000100;
		default: hex = 7'b1111111;
		endcase
	end
endmodule