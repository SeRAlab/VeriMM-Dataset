module top_module(d,clk,clrn,ena,q);input [31:0] d;
	input clk,clrn,ena;
	output reg [31:0] q;
	
	always@(posedge clrn or posedge clk)
	begin
		if (clrn == 1) 
			q<=32'h00000000;
        else if(ena)
			q<=d;
	end
endmodule