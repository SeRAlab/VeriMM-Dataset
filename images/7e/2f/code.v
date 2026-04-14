module top_module(a,in,inter,ld,clk);output reg [15:0] a;
input [15:0] in,inter;
input clk,ld;

always@(posedge clk)
begin
if(ld==1)
begin
a<=in;
end

else
begin
a<=inter;
end

end


endmodule