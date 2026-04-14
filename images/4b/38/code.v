module top_module(Reset,Clk,in,out);input Reset;
input Clk;
input [142:0]in;
output reg [142:0]out;
always@(posedge Clk)begin 
if(Reset)begin
out<=143'd0; 
end 
else begin 
out<=in; 
end 

end 
endmodule