module top_module(bcdIn, binary);input [8:0] bcdIn;					
	output reg [8:0]binary;				
	
	always@(binary)
	begin
		binary = 4'b0000;
		
		case(bcdIn[3:0])						
			1: binary = binary + 1;
			2: binary = binary + 2;
			3: binary = binary + 3;
			4: binary = binary + 4;
			5: binary = binary + 5;
			6: binary = binary + 6;
			7: binary = binary + 7;
			8: binary = binary + 8;
			9: binary = binary + 9;
		endcase
		
		case(bcdIn[7:4])						
			1: binary = binary + 10;
			2: binary = binary + 20;
			3: binary = binary + 30;
			4: binary = binary + 40;
			5: binary = binary + 50;
			6: binary = binary + 60;
			7: binary = binary + 70;
			8: binary = binary + 80;
			9: binary = binary + 90;
		endcase
		binary[8] = bcdIn[8];
	end
endmodule