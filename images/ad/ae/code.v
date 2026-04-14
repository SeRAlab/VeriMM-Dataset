module top_module(
    CLK, RSTn, En, Nus, OVERFLW
);input CLK;
	 input RSTn;
	 input En;
	 output [63:0]Nus;
	 output OVERFLW;
	 
	 
	 parameter T1USval = 6'd49;					
	 
	 
		reg [5:0]Count;
	always @ ( posedge CLK or negedge RSTn )
		if( !RSTn )
			Count <= 6'd0;
		else if( (Count == T1USval)||(!En))
			Count <= 6'd0;
		else 
			Count <= Count + 1'b1;
	
    	
		reg rOVERFLW;
    reg [63:0]Countus;
	 always @ ( posedge CLK or negedge RSTn )
		if( !RSTn )begin
			Countus <= 1'd0;
			rOVERFLW <= 1'b0;
		end
		else begin
			if(En)begin
				if(Count == T1USval)
					Countus <= Countus + 1'b1;
				else
					Countus <= Countus;
			end
			else 
				Countus <= 1'b0;
				
			if(Countus==16'hffff)
				rOVERFLW <= 1'b1;
			else
				rOVERFLW <= 1'b0;
		end
	
   
	 assign Nus = Countus;
	 assign OVERFLW = rOVERFLW;

	 
		      

endmodule