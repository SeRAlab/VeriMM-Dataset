module top_module(
    input SEL,
    input D,
    input C,
    input B,
    input A,
    output reg Z
);always @(*) begin
    case ({SEL, D, C, B, A})
        5'b00000: Z = 1;
        5'b00001: Z = 0;
        5'b00010: Z = 0;
        5'b00011: Z = 1;
        5'b00100: Z = 1;
        5'b00101: Z = 0;
        5'b00110: Z = 0;
        5'b00111: Z = 1;
        5'b01000: Z = 1;
        5'b01001: Z = 0;
        5'b01010: Z = 0;
        5'b01011: Z = 1;
        5'b01100: Z = 1;
        5'b01101: Z = 0;
        5'b01110: Z = 0;
        5'b01111: Z = 1;
        default: Z = 1;
    endcase
end

endmodule