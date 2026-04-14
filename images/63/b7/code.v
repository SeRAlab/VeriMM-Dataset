module top_module (
    input d,
    input i,
    input f,
    output reg j
);
    always @(*) begin
        case ({d, i, f})
            3'b101: j = 1'b1;
            3'b100: j = 1'b0;
            3'b111: j = 1'b1;
            3'b001: j = 1'b0;
            3'b010: j = 1'b1;
            3'b000: j = 1'b0;
            3'b011: j = 1'b0;
            3'b110: j = 1'b1;
        endcase
    end
endmodule
