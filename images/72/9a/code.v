module top_module (
    input q,
    input l,
    input d,
    input j,
    output reg g
);
    always @(*) begin
        case ({q, l, d, j})
            4'b0010: g = 1'b1;
            4'b1011: g = 1'b0;
            4'b0101: g = 1'b0;
            4'b1100: g = 1'b1;
            4'b0111: g = 1'b0;
            4'b0001: g = 1'b1;
            4'b0100: g = 1'b0;
            4'b1001: g = 1'b1;
            4'b1111: g = 1'b0;
            4'b0110: g = 1'b0;
            4'b1101: g = 1'b1;
            4'b0000: g = 1'b1;
            4'b1000: g = 1'b1;
            4'b1110: g = 1'b1;
            4'b1010: g = 1'b0;
            4'b0011: g = 1'b1;
        endcase
    end
endmodule
