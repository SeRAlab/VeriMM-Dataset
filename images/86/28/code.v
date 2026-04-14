module top_module (
    input c,
    input l,
    output reg q
);
    always @(*) begin
        case ({c, l})
            2'b01: q = 1'b1;
            2'b11: q = 1'b0;
            2'b10: q = 1'b1;
            2'b00: q = 1'b1;
        endcase
    end
endmodule
