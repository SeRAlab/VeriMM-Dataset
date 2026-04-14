module top_module(s,r,clk,rst,q,qb);input s,r,clk,rst;
	output q,qb;
	wire s,r,clk,rst,qb;
	reg q;
always @ (posedge clk)
	begin
	if(rst)
	q<=1'b0;
		else if (s==1'b0 && r==1'b0)
				q<=q;
		else if (s==1'b0&& r==1'b1)
				q<=1'b0;
		else if (s==1'b1 && r==1'b0)
				q<=1'b1;
		else if (s==1'b1 && r==1'b1)
		q<=1'bx;
		end
		assign qb=~q;endmodule