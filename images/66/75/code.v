module top_module(
    input  CLK_IN,
    input  FRAME_CLOCK,
    input  [9:0] x,
    input  [9:0] y,
    output [7:0] memRGB
    );wire [7:0] x1;
	wire [7:0] y1;
	wire [7:0] block;
	
	assign memRGB[7:5] = block[2:0]; 
	assign memRGB[4:2] = block[5:3]; 
	assign memRGB[1:0] = block[7:6]; 

	assign x1 = x[9:5];
	assign y1 = y[9:5];
	assign block = 20*y1 + x1;

	
endmodule