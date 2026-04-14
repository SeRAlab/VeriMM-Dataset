module top_module (
    input x,
    input l,
    input o,
    output reg p
);
    always @(*) begin
        case ({x, l, o})
            3'b011: p = 1'b1;
            3'b000: p = 1'b0;
            3'b010: p = 1'b0;
            3'b110: p = 1'b1;
            3'b101: p = 1'b0;
            3'b111: p = 1'b1;
            3'b001: p = 1'b0;
            3'b100: p = 1'b0;
        endcase
    end
endmodule
