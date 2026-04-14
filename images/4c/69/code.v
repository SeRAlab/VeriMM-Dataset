module bin2bcd(BIN, BCD_TENS, BCD_UNITS);
input [7:0] BIN;
output reg [3:0] BCD_TENS, BCD_UNITS;

integer i;
reg [19:0] shift_reg;

always @(*) begin
    shift_reg = {12'b0, BIN}; // Initialize shift register with binary input
    
    for (i = 0; i < 8; i = i + 1) begin
        if (shift_reg[15:12] >= 5)
            shift_reg[15:12] = shift_reg[15:12] + 3;
        if (shift_reg[19:16] >= 5)
            shift_reg[19:16] = shift_reg[19:16] + 3;
        shift_reg = shift_reg << 1;
    end
    
    BCD_TENS = shift_reg[19:16];
    BCD_UNITS = shift_reg[15:12];
end

endmodule