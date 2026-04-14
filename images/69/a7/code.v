module m_module (
    input [3:0] c,
    output reg d
);

    always @(*) begin
        case (c)
            4'b0000: d = 1;
            4'b0001: d = 0;
            4'b0010: d = 1;
            4'b0011: d = 0;
            4'b0100: d = 1;
            4'b0101: d = 0;
            4'b0110: d = 1;
            4'b0111: d = 0;
            4'b1000: d = 1;
            4'b1001: d = 0;
            4'b1010: d = 1;
            4'b1011: d = 0;
            4'b1100: d = 1;
            4'b1101: d = 0;
            4'b1110: d = 1;
            4'b1111: d = 0;
            default: d = 0; // Default case
        endcase
    end
endmodule