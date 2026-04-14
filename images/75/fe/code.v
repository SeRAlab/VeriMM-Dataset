module top_module (
    input q,
    input l,
    input o,
    output reg t
);
    always @(*) begin
        case ({q, l, o})
            3'b011: t = 1'b1;
            3'b110: t = 1'b0;
            3'b100: t = 1'b0;
            3'b000: t = 1'b1;
            3'b001: t = 1'b1;
            3'b101: t = 1'b1;
            3'b111: t = 1'b1;
            3'b010: t = 1'b0;
        endcase
    end
endmodule
