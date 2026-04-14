module MAR(input clk , input LM , input [3:0] PC_IN , output [3:0] MAR_OUT);
reg [3:0] MAR_r;
assign MAR_OUT = MAR_r;
always@(posedge clk)
begin
if(~LM)
MAR_r <= PC_IN;
end
endmodule