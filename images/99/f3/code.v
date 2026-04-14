module top_module(
    input clk,
    input A1,
    input A2,
    input A3,
    input B1,
    input C1,
    output reg X
);always @(posedge clk) begin
    case ({A1, A2, A3, B1, C1})
        5'b00000: X <= 1'b0;
        5'b00001: X <= 1'b1;
        5'b00010: X <= 1'b1;
        5'b00011: X <= 1'b1;
        5'b00100: X <= 1'b0;
        5'b00101: X <= 1'b1;
        5'b00110: X <= 1'b1;
        5'b00111: X <= 1'b1;
        5'b01000: X <= 1'b0;
        5'b01001: X <= 1'b0;
        5'b01010: X <= 1'b1;
        5'b01011: X <= 1'b1;
        5'b01100: X <= 1'b1;
        5'b01101: X <= 1'b1;
        5'b01110: X <= 1'b0;
        5'b01111: X <= 1'b0;
        5'b10000: X <= 1'b1;
        5'b10001: X <= 1'b1;
        5'b10010: X <= 1'b0;
        5'b10011: X <= 1'b0;
        5'b10100: X <= 1'b1;
        5'b10101: X <= 1'b0;
        5'b10110: X <= 1'b0;
        5'b10111: X <= 1'b0;
        5'b11000: X <= 1'b1;
        5'b11001: X <= 1'b0;
        5'b11010: X <= 1'b0;
        5'b11011: X <= 1'b0;
        5'b11100: X <= 1'b1;
        5'b11101: X <= 1'b0;
        5'b11110: X <= 1'b0;
        5'b11111: X <= 1'b0;
    endcase
end

endmodule