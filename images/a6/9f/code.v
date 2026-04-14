module top_module (
    input z,
    input x,
    output reg j
);
    always @(*) begin
        case ({z, x})
            2'b01: j = 1'b1;
            2'b00: j = 1'b1;
            2'b11: j = 1'b0;
            2'b10: j = 1'b1;
        endcase
    end
endmodule
