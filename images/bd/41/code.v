module top_module(CLK,Rst,Sm,M);input CLK,Rst,Sm;
	reg [2:0]count;
	output wire M;
	
	
	always @ (posedge CLK)
			if (Rst|M) 
				count=3'd0;
			else if (Sm)
				count=count+1'b1;
		   else 
				count=count;
				
		assign M=(count==3'b001);


endmodule