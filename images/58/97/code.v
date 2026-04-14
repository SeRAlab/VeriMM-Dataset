module top_module(
	
	input  wire [1:0] phase,

	input  wire [1:0] x,

	input  wire       y,


	input  wire [3:0] color_in,
	output reg  [1:0] color_out
);reg [3:0] colorlevel;
	reg [1:0] gridlevel;

	reg       gridy;

	reg [1:0] gridindex;


	always @*

	begin




	  case( color_in )


		4'b0000: colorlevel = 4'b0000;
		4'b0001: colorlevel = 4'b0001;

		4'b0010,

		4'b0011: colorlevel = 4'b0010;

		4'b0100: colorlevel = 4'b0011;



		4'b0101: colorlevel = 4'b0100;

		4'b0110: colorlevel = 4'b0101;

		4'b0111,

		4'b1000: colorlevel = 4'b0110;

		4'b1001: colorlevel = 4'b0111;



		4'b1010: colorlevel = 4'b1000;

		4'b1011: colorlevel = 4'b1001;

		4'b1100,

		4'b1101: colorlevel = 4'b1010;

		4'b1110: colorlevel = 4'b1011;



		default: colorlevel = 4'b1100;

	  endcase









	  gridy = y ^ (x[1] & colorlevel[0]);

	  gridindex = {gridy+phase[1], x[0]+phase[0]};

	  case(gridindex[1:0])

	    2'b00: gridlevel = 2'b00;

	    2'b01: gridlevel = 2'b10;

	    2'b10: gridlevel = 2'b11;

	    2'b11: gridlevel = 2'b01;

	  endcase

	

	  color_out = colorlevel[3:2] + ((colorlevel[1:0] > gridlevel[1:0]) ? 2'b01 : 2'b00);

	end

endmodule