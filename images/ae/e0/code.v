module top_module(clk,reset,R,S,Out);input reset, clk, R, S;
	 output Out;
	 reg   dataVal;
	 
	 always @(posedge clk, negedge reset)
		if(!reset)
			dataVal<=0;
		else if(R)
			dataVal<=0;
		else if(S)
			dataVal<=1;
		else 
			dataVal<=dataVal;
		
		assign Out=dataVal;
	 
	 endmodule