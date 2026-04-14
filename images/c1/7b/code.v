module MICRO_PROG_COUNTER (input clk , input rst , input [4:0] AR_ROM_IN , input LOAD_MICRO , input INC_MICRO , input CLEAR_MICRO , output [4:0] PRE_OUT); 
reg [4:0] PRE_OUT_r;
assign PRE_OUT = PRE_OUT_r;
always@(posedge clk or posedge rst) 
begin
if(rst)
PRE_OUT_r <= 5'h00;
else if(LOAD_MICRO)
PRE_OUT_r <= AR_ROM_IN;
else if(INC_MICRO)
PRE_OUT_r <= PRE_OUT_r + 1'b1;
else if(CLEAR_MICRO) 
PRE_OUT_r <= 5'h00; 
end
endmodule