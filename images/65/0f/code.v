module top_module (
    input w,
    input b,
    output reg p
);
    always @(*) begin
        case ({w, b})
            2'b00: p = 1'b0;
            2'b11: p = 1'b0;
            2'b01: p = 1'b0;
            2'b10: p = 1'b0;
        endcase
    end
endmodule
