module IR(input clk , input LI , input EI , input [8:0] SRAM_IN , output [4:0] IR_OUT_1 , output [3:0] IR_OUT_2);
reg [8:0] IR_OUT_r;
assign IR_OUT_1 = IR_OUT_r[8:4];
assign IR_OUT_2 = EI ? IR_OUT_r[3:0] : 4'h0;
always@(posedge clk)
begin
if(~LI)
IR_OUT_r <= SRAM_IN;
end
endmodule