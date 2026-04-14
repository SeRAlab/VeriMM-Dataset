module top_module (
    input t,
    input y,
    output reg x
);
    always @(*) begin
        case ({t, y})
            2'b10: x = 1'b1;
            2'b11: x = 1'b1;
            2'b01: x = 1'b1;
            2'b00: x = 1'b1;
        endcase
    end
endmodule
