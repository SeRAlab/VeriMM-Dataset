module top_module (
    input o,
    input c,
    input q,
    output reg z
);
    always @(*) begin
        case ({o, c, q})
            3'b010: z = 1'b1;
            3'b101: z = 1'b1;
            3'b110: z = 1'b0;
            3'b111: z = 1'b1;
            3'b000: z = 1'b1;
            3'b001: z = 1'b0;
            3'b011: z = 1'b1;
            3'b100: z = 1'b1;
        endcase
    end
endmodule
