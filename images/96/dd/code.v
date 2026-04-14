module top_module (
    input c,
    input l,
    output reg o
);
    always @(*) begin
        case ({c, l})
            2'b10: o = 1'b0;
            2'b01: o = 1'b1;
            2'b11: o = 1'b0;
            2'b00: o = 1'b0;
        endcase
    end
endmodule
