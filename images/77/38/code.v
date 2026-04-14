module top_module(input [3:0] x, output [3:0] an, output [6:0] seg);assign an = 4'b0001;
	assign  seg[0] = (~x[0] & ~x[1] & x[2]) | (x[0] & ~x[1] & ~x[2] & ~x[3]); 
	assign  seg[1] = (x[0] ^ x[1]) & x[2]; 
	assign  seg[2] = ~x[0] & x[1] & ~x[2]; 
	assign  seg[3] = (~x[0] & ~x[1] & x[2]) | (x[0] & ~x[1] & ~x[2] & ~x[3]) | (x[0] & x[1] & x[2]); 
	assign  seg[4] = (x[0] ) | (~x[0] & ~x[1] & x[2]); 
	assign  seg[5] = (x[0] & x[1]) | (x[1] & ~x[2]) | (x[0] & ~x[2] & ~x[3]); 
	assign  seg[6] = (x[0] & x[1] & x[2]) | (~x[1] & ~x[2] & ~x[3]); 
endmodule