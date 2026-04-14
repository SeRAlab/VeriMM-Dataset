module top_module(D,PRE,CLR,CLK,Q,Qn);input D,PRE,CLR,CLK;
	output reg Q,Qn;
	
	always@(negedge PRE or negedge CLR or posedge CLK)
		if(!PRE)
			begin
			Q <= 1'b1;
			Qn <= 1'b0;
			end
		else if(!CLR)
			begin
			Q <= 1'b0;
			Qn <= 1'b1;
			end
		else
			begin
			Q <= D;
			Qn <= ~D;
			end

endmodule