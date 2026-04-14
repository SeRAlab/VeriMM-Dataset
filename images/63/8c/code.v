module top_module (
    input n,
    input j,
    input a,
    output reg d
);
    always @(*) begin
        case ({n, j, a})
            3'b001: d = 1'b0;
            3'b101: d = 1'b0;
            3'b110: d = 1'b0;
            3'b011: d = 1'b1;
            3'b010: d = 1'b1;
            3'b100: d = 1'b1;
            3'b111: d = 1'b0;
            3'b000: d = 1'b0;
        endcase
    end
endmodule
