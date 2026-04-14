module top_module(
    input [3:0] ABCD,
    output reg [1:0] Y
);always @* begin
    case(ABCD)
        4'b0001: Y = 2'b00;
        4'b0010: Y = 2'b01;
        4'b0100: Y = 2'b10;
        4'b1000: Y = 2'b11;
        4'b0011: Y = 2'b01;
        4'b0101: Y = 2'b10;
        4'b0110: Y = 2'b10;
        4'b1001: Y = 2'b11;
        4'b0111: Y = 2'b10;
        4'b1011: Y = 2'b11;
        4'b1101: Y = 2'b11;
        4'b1110: Y = 2'b11;
        default: Y = 2'b00;
    endcase
end

endmodule