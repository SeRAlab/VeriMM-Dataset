module top_module(S,R,Q, Qnot);input wire S, R; 
	output Q, Qnot; 
	
	reg rQ, rQnot; 
	
	always @ (*) begin 

		rQ <=  ~(R |  rQnot); 
		rQnot <=  ~(S | rQ); 

	end 

	assign Q = rQ; 
	assign Qnot = rQnot; 

endmodule