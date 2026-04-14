module top_module (
    input h,
    input c,
    output reg l
);
    always @(*) begin
        case ({h, c})
            2'b11: l = 1'b0;
            2'b10: l = 1'b1;
            2'b01: l = 1'b0;
            2'b00: l = 1'b1;
        endcase
    end
endmodule
