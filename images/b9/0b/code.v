module top_module (
    input [3:0] h,
    output reg s
);

    always @(*) begin
        case (h)
            4'b0000: s = 1;
            4'b0001: s = 0;
            4'b0010: s = 0;
            4'b0011: s = 1;
            4'b0100: s = 1;
            4'b0101: s = 1;
            4'b0110: s = 0;
            4'b0111: s = 1;
            4'b1000: s = 1;
            4'b1001: s = 0;
            4'b1010: s = 1;
            4'b1011: s = 0;
            4'b1100: s = 0;
            4'b1101: s = 1;
            4'b1110: s = 1;
            4'b1111: s = 0;
            default: s = 0; // Default case
        endcase
    end
endmodule