module ACC(input clk , input [8:0] ACC_IN , input LA , input EA , output [8:0] ACC_ALU , output [8:0] ACC_BUS);
reg[8:0] ACC_r;
assign ACC_ALU = ACC_r;
assign ACC_BUS = EA ? ACC_r : 9'h000;
always@(posedge clk)
begin
if(~LA)
ACC_r <= ACC_IN;
end
endmodule