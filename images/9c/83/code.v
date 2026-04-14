module top_module(rna,rnb,d,wn,we,clk,clrn,qa,qb
    );input [4:0] rna,rnb,wn;
    input [31:0] d;
	 input we,clk,clrn;
	 output [31:0] qa,qb;
	 integer i;
	 reg [31:0] register [1:31];		
	 assign qa=((rna==0)?0:register[rna]);
	 assign qb=((rnb==0)?0:register[rnb]);
	 always @(negedge clk or negedge clrn)
	     if(clrn==0)
		  begin
		  for(i=1;i<32;i=i+1)
		      register[i]<=0;
		  end
		  else if((wn!=0)&&we)
		     register[wn]<=d;
endmodule