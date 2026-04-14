module top_module (
    input g,
    input r,
    input s,
    output reg c
);
    always @(*) begin
        case ({g, r, s})
            3'b100: c = 1'b0;
            3'b110: c = 1'b0;
            3'b111: c = 1'b0;
            3'b101: c = 1'b0;
            3'b000: c = 1'b1;
            3'b001: c = 1'b1;
            3'b010: c = 1'b1;
            3'b011: c = 1'b1;
        endcase
    end
endmodule
