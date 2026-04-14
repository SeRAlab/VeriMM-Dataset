module top_module (
    input x,
    input p,
    input m,
    output reg r
);
    always @(*) begin
        case ({x, p, m})
            3'b011: r = 1'b0;
            3'b000: r = 1'b0;
            3'b101: r = 1'b0;
            3'b111: r = 1'b1;
            3'b100: r = 1'b0;
            3'b010: r = 1'b0;
            3'b001: r = 1'b1;
            3'b110: r = 1'b0;
        endcase
    end
endmodule
