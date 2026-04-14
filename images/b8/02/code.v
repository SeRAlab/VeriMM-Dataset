module top_module(
    input [4:0] BIN,
    input clk,           // added clk input
    output reg [3:0] BCD0,
    output reg [3:0] BCD1
);reg [3:0] bcd0_reg, bcd1_reg;
reg [4:0] shift_reg;
integer i;             // declared integer i

always @(*) begin
    shift_reg = {BIN, 1'b0};
end

always @(posedge clk) begin
    bcd0_reg <= 4'b0000;
    bcd1_reg <= 4'b0000;
    
    for (i = 0; i < 5; i = i + 1) begin
        if (shift_reg[3:0] >= 5) begin
            bcd0_reg = bcd0_reg + 1;
        end
        
        if (bcd0_reg[3]) begin
            bcd0_reg = bcd0_reg + 3;
        end
        
        if (bcd1_reg[3]) begin
            bcd1_reg = bcd1_reg + 3;
        end
        
        bcd0_reg = bcd0_reg << 1;
        bcd1_reg = bcd1_reg << 1;
        bcd0_reg[0] = shift_reg[4];
        bcd1_reg[0] = bcd0_reg[3];
        shift_reg = shift_reg << 1;
    end
    
    BCD0 <= bcd0_reg;
    BCD1 <= bcd1_reg;
end

endmodule