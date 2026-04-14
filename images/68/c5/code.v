module top_module(d,clk,resetn,en,q);input clk;
input resetn;
input en;
input  d;
output q;
reg q;

always @(posedge clk )		
begin
	if (resetn==0)
		q<=0;
	else if (en==1)
		q<=d;
end

endmodule