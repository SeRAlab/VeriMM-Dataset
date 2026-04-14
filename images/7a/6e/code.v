module top_module(
    input [3:0] DATA_IN,
    output reg [6:0] SEVEN_SEG_OUT
);always @(*) begin
    case (DATA_IN)
        4'b0000: SEVEN_SEG_OUT = 7'b0111111;
        4'b0001: SEVEN_SEG_OUT = 7'b0000110;
        4'b0010: SEVEN_SEG_OUT = 7'b1011011;
        4'b0011: SEVEN_SEG_OUT = 7'b1001111;
        4'b0100: SEVEN_SEG_OUT = 7'b1100110;
        4'b0101: SEVEN_SEG_OUT = 7'b1101101;
        4'b0110: SEVEN_SEG_OUT = 7'b1111101;
        4'b0111: SEVEN_SEG_OUT = 7'b0000111;
        4'b1000: SEVEN_SEG_OUT = 7'b1111111;
        4'b1001: SEVEN_SEG_OUT = 7'b1101111;
        default: SEVEN_SEG_OUT = 7'b0000000;
    endcase
end

endmodule