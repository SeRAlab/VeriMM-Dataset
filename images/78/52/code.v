module top_module(
    input [3:0] BCD,
    input clk,
    input reset,
    output reg [6:0] SEG
);reg [3:0] bcd_reg;
reg [2:0] stage;

always @(*) begin
    case (stage)
        0: bcd_reg <= BCD;
        1: bcd_reg <= bcd_reg << 1;
        2: bcd_reg <= bcd_reg << 1;
        3: bcd_reg <= bcd_reg << 1;
        4: bcd_reg <= bcd_reg << 1;
        5: bcd_reg <= bcd_reg << 1;
        6: bcd_reg <= bcd_reg << 1;
        7: bcd_reg <= bcd_reg << 1;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        SEG <= 7'b0000000;
        stage <= 0;
    end else begin
        case (stage)
            0: SEG <= 7'b0111111; // 0
            1: SEG <= 7'b0000110; // 1
            2: SEG <= 7'b1011011; // 2
            3: SEG <= 7'b1001111; // 3
            4: SEG <= 7'b1100110; // 4
            5: SEG <= 7'b1101101; // 5
            6: SEG <= 7'b1111101; // 6
            7: SEG <= 7'b0000111; // 7
        endcase
        
        if (stage == 7) begin
            stage <= 0;
        end else begin
            stage <= stage + 1;
        end
    end
end

endmodule