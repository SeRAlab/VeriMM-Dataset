module top_module(
    input [2:0] A,
    output reg [6:0] SEG
);always @(*) begin
    case(A)
        3'b000: SEG = 7'b0111111;
        3'b001: SEG = 7'b0000110;
        3'b010: SEG = 7'b1011011;
        3'b011: SEG = 7'b1001111;
        3'b100: SEG = 7'b1100110;
        3'b101: SEG = 7'b1101101;
        3'b110: SEG = 7'b1111101;
        3'b111: SEG = 7'b0000111;
        default: SEG = 7'b1111111;
    endcase
end

endmodule