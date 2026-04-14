module top_module(Set , ReSet , CE , CLK , Q , D);input Set , ReSet , CE , CLK , D ;
output reg Q;

always @(posedge CLK)
	begin
		if(ReSet == 1)
			Q = 1'b0;
		else if(Set == 1)
			Q = 1'b1;
		else if(CE == 1)
			Q = D;
	end

endmodule