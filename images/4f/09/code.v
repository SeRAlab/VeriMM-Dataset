module top_module (
    input k,
    input c,
    input i,
    input y,
    output reg j
);
    always @(*) begin
        case ({k, c, i, y})
            4'b1101: j = 1'b1;
            4'b0111: j = 1'b1;
            4'b1000: j = 1'b0;
            4'b0101: j = 1'b1;
            4'b1001: j = 1'b0;
            4'b1011: j = 1'b0;
            4'b0010: j = 1'b0;
            4'b0001: j = 1'b1;
            4'b0100: j = 1'b0;
            4'b1110: j = 1'b0;
            4'b1100: j = 1'b1;
            4'b1111: j = 1'b0;
            4'b1010: j = 1'b0;
            4'b0000: j = 1'b1;
            4'b0110: j = 1'b0;
            4'b0011: j = 1'b0;
        endcase
    end
endmodule
