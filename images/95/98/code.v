module top_module (
    input j,
    input t,
    input k,
    output reg b
);
    always @(*) begin
        case ({j, t, k})
            3'b000: b = 1'b1;
            3'b111: b = 1'b0;
            3'b110: b = 1'b0;
            3'b001: b = 1'b1;
            3'b011: b = 1'b1;
            3'b100: b = 1'b1;
            3'b010: b = 1'b0;
            3'b101: b = 1'b1;
        endcase
    end
endmodule
