module PC(input clk , input rst , input EP , input CP , output[3:0] PC_OUT);
reg [3:0] PC_OUT_r;
assign PC_OUT = EP ? PC_OUT_r: 4'h0;
always@(posedge clk or posedge rst)
begin
if(rst)
PC_OUT_r <= 4'h0;
else if(CP)
PC_OUT_r <= PC_OUT_r + 1'b1;
end
endmodule