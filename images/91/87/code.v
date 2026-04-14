module top_module(en,clr,clk,q);input en,clr,clk;
output [3:0] q;
reg [3:0] q;

always@(posedge clk)
begin
if(clr) q<=4'b0000;
else if(~en) q<=q;
else if(q==4'b0101) q<=4'b0000;
else q<=q+1'b1;
end
endmodule