module top_module (
    input z,
    input x,
    output reg n
);
    always @(*) begin
        case ({z, x})
            2'b10: n = 1'b0;
            2'b11: n = 1'b1;
            2'b00: n = 1'b1;
            2'b01: n = 1'b0;
        endcase
    end
endmodule
