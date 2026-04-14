module top_module(y,ones,tens,hundreds,thousands);input [15:0] y;
	
	output [3:0] ones,tens,hundreds,thousands;
	
	wire [3:0] ones,tens,hundreds,thousands;
	wire [15:0] a;
	wire [15:0] b;
	wire [15:0] c;
	
	
	assign a = y % 11'b11111101000; 
	assign b = y % 11'b00001100100;
	assign c = y % 11'b00000001010;


	assign thousands = (y-a)/11'b11111101000;
	assign hundreds = (y-b-(y-a))/11'b00001100100;
	assign tens =     (y-(y-c-(y-b-(y-a))-(y-a)))/11'b00000001010;
	assign ones =     (y-(y-a)-(y-(b+(y-a))-(y-(y-c-(y-(b+(y-a))-(y-a/1000))))));


endmodule