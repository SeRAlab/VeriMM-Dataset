module top_module(A, B, AeqB, AgtB, AltB);input [3:0] A;
	input [3:0] B;
	output AeqB, AgtB, AltB;
	reg AeqB, AgtB, AltB;
		
	always @(A or B)
	begin
		
		if(A == B)
			AeqB = 1;
		else 
			AeqB = 0; 

		if (A > B)
			AgtB = 1;
		else 
			AgtB = 0; 

		if (A < B) 
			AltB = 1;
		else
			AltB = 0;
	end
endmodule