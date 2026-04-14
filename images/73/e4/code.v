module top_module (
    input m,
    input e,
    output reg q
);
    always @(*) begin
        case ({m, e})
            2'b00: q = 1'b0;
            2'b01: q = 1'b1;
            2'b11: q = 1'b1;
            2'b10: q = 1'b0;
        endcase
    end
endmodule
