module top_module(
	input clk,
	input [6:0] value,
	output[15:0] display
	);reg [15:0] encoding = 16'b00000000_00000000;
	
	always @ (posedge clk) begin
	
		case(value)
			
          4'd0 : encoding[15:0] = 16'b11000000_11000000; 
          4'd1 : encoding[15:0] = 16'b11000000_11111001; 
          4'd2 : encoding[15:0] = 16'b11000000_10100100; 
          4'd3 : encoding[15:0] = 16'b11000000_10110000; 
          4'd4 : encoding[15:0] = 16'b11000000_10011001; 
          4'd5 : encoding[15:0] = 16'b11000000_10010010; 
          4'd6 : encoding[15:0] = 16'b11000000_10000010; 
          4'd7 : encoding[15:0] = 16'b11000000_11111000; 
          4'd8 : encoding[15:0] = 16'b11000000_10000000; 
          4'd9 : encoding[15:0] = 16'b11000000_10010000; 
          4'd10: encoding[15:0] = 16'b11111001_11000000; 
		endcase
	end	
	assign display = encoding[15:0];
endmodule