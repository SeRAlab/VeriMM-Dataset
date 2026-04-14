module top_module (
    input r,
    input q,
    input z,
    input t,
    output reg n
);
    always @(*) begin
        case ({r, q, z, t})
            4'b0100: n = 1'b1;
            4'b1111: n = 1'b1;
            4'b0001: n = 1'b1;
            4'b1010: n = 1'b1;
            4'b0011: n = 1'b0;
            4'b0000: n = 1'b0;
            4'b1000: n = 1'b0;
            4'b1100: n = 1'b1;
            4'b0111: n = 1'b1;
            4'b1101: n = 1'b0;
            4'b0110: n = 1'b0;
            4'b1001: n = 1'b0;
            4'b0010: n = 1'b0;
            4'b0101: n = 1'b0;
            4'b1110: n = 1'b0;
            4'b1011: n = 1'b0;
        endcase
    end
endmodule
