module top_module (
    input f,
    input z,
    output reg a
);
    always @(*) begin
        case ({f, z})
            2'b11: a = 1'b1;
            2'b00: a = 1'b1;
            2'b01: a = 1'b0;
            2'b10: a = 1'b0;
        endcase
    end
endmodule
