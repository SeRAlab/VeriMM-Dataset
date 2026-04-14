module top_module(R,S,Q,Qn);input R,S;
	output Q,Qn;
	
	wire R,S,Q,Qn;
	
	assign    Q=~(S|Qn);
   assign    Qn=~(R|Q);
			
	
	

endmodule