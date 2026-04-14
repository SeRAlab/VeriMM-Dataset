module top_module(CLK,POSROTAF,ROTBF,EV,IZ);input CLK,ROTBF,POSROTAF;
	output reg EV,IZ;
	

	
	always@(posedge CLK)
		begin
			if(POSROTAF)
				begin
					EV=1;
					IZ=ROTBF;
				end
			else
				begin
					EV=0;
					IZ=IZ;
				end
		end
	
endmodule