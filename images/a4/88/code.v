module top_module(a,b,c,d,e,f,g,A,B,C,D);input wire A,B,C,D;
		output wire a,b,c,d,e,f,g;
		
		wire A_,B_,C_,D_;
		wire[0:9] w;
		
		not(A_,A); not(B_,B); not(C_,C); not(D_,D);
		
		and(w[0],A_,B_,C_,D_); and(w[1],A_,B_,C_,D);
		and(w[2],A_,B_,C,D_);  and(w[3],A_B_,C,D);
		and(w[4],A_,B,C_,D_);  and(w[5],A_,B,C_,D);
		and(w[6],A_,B,C,D_);   and(w[7],A_,B,C,D);	 							  
				       and(w[9],A,B_,C_,D); 
		
		or(a,w[0],w[4]); 
		or(b,w[5],w[6]);
		assign c = w[2];
		or(d,w[1],w[4],w[7]);
		or(e,w[1],w[3],w[4],w[5],w[7],w[9]);
		or(f,w[1],w[2],w[3],w[7]);
		or(g,w[0],w[1],w[7]);
		
		
endmodule