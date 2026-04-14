module top_module(A,B,C,D,W,X,Y,Z);input A,B,C,D;
	output W,X,Y,Z;
	assign W = A | (B&C) | (B&D);                                                   
	assign X = (~B&C) | (~B & D) | (B & ~C & ~D);
	assign Y = ~( C ^ D);
	assign Z = ~D;endmodule