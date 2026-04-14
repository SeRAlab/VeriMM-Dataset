module top_module(
input clk,reset,
output [3:0] dout
    );reg[3:0] temp;   
always@(posedge(clk))
begin
if(reset == 1'b1)
   temp <= 4'b0000;
else
   temp <= temp + 1;
end
assign dout = temp;
endmodule