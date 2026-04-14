module top_module (
    input a,
    input b,
    input c,
    output reg q
);
    always @(*) begin
        case ({a, b, c})
            3'b110: q = 1'b1;
            3'b101: q = 1'b1;
            3'b001: q = 1'b1;
            3'b011: q = 1'b1;
            3'b100: q = 1'b0;
            3'b111: q = 1'b0;
            3'b000: q = 1'b0;
            3'b010: q = 1'b1;
        endcase
    end
endmodule
