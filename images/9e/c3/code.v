module top_module(
				Q,
				D,
				rst,
				clk
		    );output [7:0] Q;
input D,rst,clk;
reg[7:0] Q;

integer i;

always@(posedge clk)
	if(!rst)
		Q<=8'b000000;
	else
		begin
			for(i=7;i>0;i=i-1)
			Q[i]<=Q[i-1];
			Q[0]<=D;
		end		   
endmodule