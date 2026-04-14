module top_module(inA, inB, inC, sum, carry
	);input inA, inB, inC;
	output sum, carry;

	
	
	
	xor(sum, inA, inB, inC);

	
	assign carry = (inA*inB) | (inB*inC) | (inC*inA);

endmodule