module top_module(ENB, HEX);input	ENB;
	output [6:0] HEX;
	
	wire [3:0] V;

	assign V = 4'b0 | ENB;

	wire A = V[0];
	wire B = V[1];
	wire C = V[2];
	wire D = V[3];

	wire common = D&B | D&C;

	
	assign HEX[0] = common | C&~B&~A | ~D&~C&~B&A;
	assign HEX[1] = common | C&~B&A | C&B&~A;
	assign HEX[2] = common | ~C&B&~A;
	assign HEX[3] = common | C&~B&~A | C&B&A | ~D&~C&~B&A;
	assign HEX[4] = common | A | C&~B;
	assign HEX[5] = common | B&A | ~D&~C&A | ~C&B&~A;
	assign HEX[6] = common | ~D&~C&~B | C&B&A;endmodule