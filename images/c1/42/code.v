module SRAM(input CE , input [3:0] MAR_IN , output[8:0] SRAM_OUT);
reg [8:0] SRAM_r [15:0];
assign SRAM_OUT = (~CE) ? SRAM_r[MAR_IN] : 9'h000;
always@(MAR_IN)
begin
SRAM_r[0] <= 9'b000001001;
SRAM_r[1] <= 9'b000011010; 
SRAM_r[2] <= 9'b000101011; 
SRAM_r[3] <= 9'b000111111; 
SRAM_r[4] <= 9'b111111111; 
SRAM_r[5] <= 9'b111111111; 
SRAM_r[6] <= 9'b111111111; 
SRAM_r[7] <= 9'b111111111; 
SRAM_r[8] <= 9'b111111111; 
SRAM_r[9] <= 9'b000000001; 
SRAM_r[10] <= 9'b000000010; 
SRAM_r[11] <= 9'b000000001; 
SRAM_r[12] <= 9'b111111111; 
SRAM_r[13] <= 9'b111111111; 
SRAM_r[14] <= 9'b111111111; 
SRAM_r[15] <= 9'b111111111; 
end
endmodule