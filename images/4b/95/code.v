module top_module (
    input p,
    input v,
    input r,
    input a,
    output reg o
);
    always @(*) begin
        case ({p, v, r, a})
            4'b1010: o = 1'b1;
            4'b1001: o = 1'b1;
            4'b0110: o = 1'b1;
            4'b1100: o = 1'b0;
            4'b0100: o = 1'b0;
            4'b0000: o = 1'b0;
            4'b1110: o = 1'b0;
            4'b0001: o = 1'b1;
            4'b0011: o = 1'b0;
            4'b1011: o = 1'b0;
            4'b1101: o = 1'b1;
            4'b0101: o = 1'b0;
            4'b1000: o = 1'b1;
            4'b0111: o = 1'b0;
            4'b1111: o = 1'b0;
            4'b0010: o = 1'b0;
        endcase
    end
endmodule
