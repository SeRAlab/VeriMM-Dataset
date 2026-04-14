module top_module(out,com,clk,in1,in0);output [7:0] out;
	output [1:0] com;
	input clk;
	input [3:0] in1;
	input [3:0] in0;
	reg [7:0] digit;
	reg [1:0] regcom = 2'b10;
	reg [15:0] clkdiv;
	reg [3:0] in;
	
	always@(posedge clk)begin
		clkdiv = clkdiv + 1;
		if(clkdiv == 0) begin
			regcom = {regcom[0],regcom[1]};
			case(regcom)
				2'b10:	in = in0;
				2'b01:	in = in1;
				default: in = 0000;
			endcase
			case(in)
				0: digit = 8'b00111111;
				1: digit = 8'b00000110;
				2: digit = 8'b01011011;
				3: digit = 8'b01001111;
				4: digit = 8'b01100110;
				5: digit = 8'b01101101;
				6: digit = 8'b01111101;
				7: digit = 8'b00000111;
				8: digit = 8'b01111111;
				9: digit = 8'b01101111;
				10:	digit = 8'b01110111;
				11:	digit = 8'b01111100;
				12:	digit = 8'b00111001;
				13:	digit = 8'b01011110;
				14:	digit = 8'b01111001;
				15:	digit = 8'b01110001;
				default:	digit = 8'b00000000;
			endcase
		end
	end
	assign out = digit;
	assign com = regcom;endmodule