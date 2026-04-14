module top_module(
    input [2:0] color,
    output [7:0] rgb
    );parameter BACKGROUND = 0;
	parameter SPACESHIP = 1;
	parameter ALIENS0 = 2;
	parameter ALIENS1 = 3;
	parameter ALIENS2 = 4;
	parameter ALIENS3 = 5;
	parameter LASER =6;
	parameter NONE = 7;
	
	reg [7:0] rgb_reg;
	assign rgb = rgb_reg ;
	
	always @(color) begin
		case (color)
			0 : rgb_reg = 8'b00000000 ;
			1 : rgb_reg = 8'b11100000 ;
			2 : rgb_reg = 8'b00011100 ;
			3 : rgb_reg = 8'b11111100 ;
			4 : rgb_reg = 8'b00011111 ;
			5 : rgb_reg = 8'b11100011 ;
			6 : rgb_reg = 8'b11100000 ;
			7 : rgb_reg = 8'b00000000 ;
			default : rgb_reg = 8'b00000000 ;
		endcase
		

end
endmodule