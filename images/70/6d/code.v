module top_module (
    input b,
    input s,
    output reg g
);
    always @(*) begin
        case ({b, s})
            2'b00: g = 1'b1;
            2'b01: g = 1'b0;
            2'b11: g = 1'b1;
            2'b10: g = 1'b1;
        endcase
    end
endmodule
