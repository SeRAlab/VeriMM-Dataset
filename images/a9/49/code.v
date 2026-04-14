module top_module (
    input d,
    input q,
    input u,
    output reg a
);
    always @(*) begin
        case ({d, q, u})
            3'b011: a = 1'b1;
            3'b000: a = 1'b0;
            3'b010: a = 1'b1;
            3'b100: a = 1'b0;
            3'b101: a = 1'b0;
            3'b110: a = 1'b1;
            3'b001: a = 1'b0;
            3'b111: a = 1'b1;
        endcase
    end
endmodule
