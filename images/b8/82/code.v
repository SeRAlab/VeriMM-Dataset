module top_module (
    input n,
    input z,
    input k,
    input b,
    output reg l
);
    always @(*) begin
        case ({n, z, k, b})
            4'b0100: l = 1'b0;
            4'b1100: l = 1'b1;
            4'b0000: l = 1'b1;
            4'b1001: l = 1'b1;
            4'b1000: l = 1'b0;
            4'b1011: l = 1'b0;
            4'b1110: l = 1'b0;
            4'b1101: l = 1'b1;
            4'b0101: l = 1'b0;
            4'b1010: l = 1'b1;
            4'b0010: l = 1'b0;
            4'b0011: l = 1'b1;
            4'b0001: l = 1'b0;
            4'b0110: l = 1'b1;
            4'b1111: l = 1'b0;
            4'b0111: l = 1'b1;
        endcase
    end
endmodule
