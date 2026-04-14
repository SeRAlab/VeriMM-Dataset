module top_module (
    input d,
    input s,
    output reg a
);
    always @(*) begin
        case ({d, s})
            2'b11: a = 1'b1;
            2'b10: a = 1'b1;
            2'b01: a = 1'b1;
            2'b00: a = 1'b1;
        endcase
    end
endmodule
