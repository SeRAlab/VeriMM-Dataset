module OREG(input clk , input [8:0] O_IN , input LO , output [8:0] O_OUT);
reg [8:0] O_OUT_r;
assign O_OUT = O_OUT_r;
always@(posedge clk)
begin
if(~LO)
O_OUT_r <= O_IN;
end
endmodule