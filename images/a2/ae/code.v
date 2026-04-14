module top_module (
    input s,
    input t,
    input f,
    output reg n
);
    always @(*) begin
        case ({s, t, f})
            3'b001: n = 1'b0;
            3'b011: n = 1'b1;
            3'b111: n = 1'b1;
            3'b101: n = 1'b0;
            3'b000: n = 1'b0;
            3'b100: n = 1'b1;
            3'b010: n = 1'b1;
            3'b110: n = 1'b1;
        endcase
    end
endmodule
