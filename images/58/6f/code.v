module top_module (
    input e,
    input j,
    input q,
    input g,
    output reg c
);
    always @(*) begin
        case ({e, j, q, g})
            4'b1010: c = 1'b0;
            4'b0010: c = 1'b1;
            4'b1011: c = 1'b1;
            4'b1111: c = 1'b1;
            4'b0011: c = 1'b0;
            4'b1001: c = 1'b1;
            4'b1101: c = 1'b0;
            4'b0110: c = 1'b0;
            4'b0000: c = 1'b1;
            4'b1110: c = 1'b1;
            4'b1000: c = 1'b0;
            4'b0100: c = 1'b0;
            4'b0111: c = 1'b1;
            4'b0001: c = 1'b0;
            4'b0101: c = 1'b1;
            4'b1100: c = 1'b1;
        endcase
    end
endmodule
