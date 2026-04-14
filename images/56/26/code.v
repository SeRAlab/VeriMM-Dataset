module top_module(
    input  wire  [3:0] value,
    output reg   [6:0] seg
);localparam CHAR_N        = 7'b1111111;
    localparam CHAR_0        = 7'b1000000;
    localparam CHAR_1        = 7'b1111001;
    localparam CHAR_2        = 7'b0100100;
    localparam CHAR_3        = 7'b0110000;
    localparam CHAR_4        = 7'b0011001;
    localparam CHAR_5        = 7'b0010010;
    localparam CHAR_6        = 7'b0000010;
    localparam CHAR_7        = 7'b1111000;
    localparam CHAR_8        = 7'b0000000;
    localparam CHAR_9        = 7'b0010000;
    localparam CHAR_A        = 7'b0001000;
    localparam CHAR_B        = 7'b0000011;
    localparam CHAR_C        = 7'b1000110;
    localparam CHAR_D        = 7'b0100001;
    localparam CHAR_E        = 7'b0000110;
    localparam CHAR_F        = 7'b0001110;

    always @(*) begin
        case (value)
        4'h0: seg <= CHAR_0;
        4'h1: seg <= CHAR_1;
        4'h2: seg <= CHAR_2;
        4'h3: seg <= CHAR_3;
        4'h4: seg <= CHAR_4;
        4'h5: seg <= CHAR_5;
        4'h6: seg <= CHAR_6;
        4'h7: seg <= CHAR_7;
        4'h8: seg <= CHAR_8;
        4'h9: seg <= CHAR_9;
        4'hA: seg <= CHAR_A;
        4'hB: seg <= CHAR_B;
        4'hC: seg <= CHAR_C;
        4'hD: seg <= CHAR_D;
        4'hE: seg <= CHAR_E;
        4'hF: seg <= CHAR_F;
        default: seg <= CHAR_N;
        endcase
    end

endmodule