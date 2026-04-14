module top_module(
input [3:0]d,
input clk,rst,ld,und,
output reg [3:0]q
    );always@(posedge clk)
begin
if(rst)
q<=4'b0000;
else if(ld)
q<=d;
else if(und)
q<=q+1;
else
q<=q-1;
end
endmodule