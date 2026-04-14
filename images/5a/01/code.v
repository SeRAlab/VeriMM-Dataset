module top_module(PRE,CLR,CLK,D,QN,QNF
    );input PRE,CLR,CLK,D;
	output reg QN,QNF;
	
	always @(posedge CLK or negedge PRE or negedge CLR)
	begin
		if(!PRE)
			begin
				QN<=1;
				QNF<=0;
			end
		else if(!CLR)
			begin
				QN<=0;
				QNF<=1;
			end
		else if(CLK==0)
			begin
				;
			end
		else if(D==0)
			begin
				QN<=0;
				QNF<=1;
			end
		else
			begin
				QN<=1;
				QNF<=0;
			end
	end

endmodule