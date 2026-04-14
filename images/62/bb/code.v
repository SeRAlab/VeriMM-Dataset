module top_module (
    input k,
    input b,
    output reg a
);
    always @(*) begin
        case ({k, b})
            2'b00: a = 1'b0;
            2'b11: a = 1'b1;
            2'b01: a = 1'b0;
            2'b10: a = 1'b1;
        endcase
    end
endmodule
