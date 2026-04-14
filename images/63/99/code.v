module top_module (
    input s,
    input d,
    input a,
    input v,
    output reg t
);
    always @(*) begin
        case ({s, d, a, v})
            4'b1001: t = 1'b1;
            4'b1000: t = 1'b0;
            4'b1101: t = 1'b1;
            4'b0101: t = 1'b1;
            4'b0001: t = 1'b0;
            4'b1110: t = 1'b1;
            4'b0010: t = 1'b0;
            4'b0100: t = 1'b1;
            4'b0000: t = 1'b1;
            4'b1100: t = 1'b1;
            4'b1011: t = 1'b0;
            4'b1010: t = 1'b0;
            4'b0111: t = 1'b1;
            4'b0011: t = 1'b1;
            4'b0110: t = 1'b1;
            4'b1111: t = 1'b1;
        endcase
    end
endmodule
