module top_module(Q,M,Quo,Rem
    );input [15:0] Q, M;
	 output [15:0] Quo, Rem;
	 reg [15:0] Quo = 0, Rem = 0;
	 reg [15:0] a1,b1,p1;
	 integer i;
	 
	 always @(Q or M)
	 begin
		
		a1 = Q;
		b1 = M;
		p1 = 0;
		
		if(a1[15]==1)
		a1=0-a1;
		
		if(b1[15]==1)
		b1=0-b1;
		
		if((b1[15]==1)&&(a1[15]==1))begin
		b1 = 0-b1;
		a1 = 0-a1;
		end
		
		for(i=0;i<16;i=i+1)begin
			
			p1 = {p1[14:0],a1[15]};
			a1[15:1] = a1[14:0];
			p1 = p1-b1;
			if(p1[15]==1)begin
				a1[0] = 0;
				p1 = p1+b1; end
			else
				a1[0] = 1;
			
		end
		
		if((Q[15]==1) && (M[15]==0))
		begin
		Quo = 0-a1;
		Rem = 0-p1;
		end
		
		else if ((Q[0]==0) && (M[15]==1))
		begin
		Quo = 0-a1;
		Rem = p1;
		end
		
		if((Q[15]==1) && (M[15]==1))
		begin
		Quo = a1;
		Rem =0- p1;
		end
		
		else
		begin
		Quo = a1;
		Rem = p1;
		end
	
			
end
endmodule