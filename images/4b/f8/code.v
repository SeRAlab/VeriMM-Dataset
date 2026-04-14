module top_module (
    input a,
    input h,
    input o,
    output reg j
);
    always @(*) begin
        case ({a, h, o})
            3'b001: j = 1'b0;
            3'b011: j = 1'b1;
            3'b101: j = 1'b0;
            3'b111: j = 1'b0;
            3'b110: j = 1'b1;
            3'b100: j = 1'b1;
            3'b000: j = 1'b1;
            3'b010: j = 1'b1;
        endcase
    end
endmodule
