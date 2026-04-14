module top_module (
    input e,
    input z,
    input x,
    output reg c
);
    always @(*) begin
        case ({e, z, x})
            3'b000: c = 1'b1;
            3'b011: c = 1'b1;
            3'b101: c = 1'b1;
            3'b100: c = 1'b1;
            3'b010: c = 1'b1;
            3'b001: c = 1'b1;
            3'b111: c = 1'b1;
            3'b110: c = 1'b0;
        endcase
    end
endmodule
