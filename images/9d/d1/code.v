module t_module (
    input [3:0] l,
    output reg n
);

    always @(*) begin
        case (l)
            4'b0000: n = 0;
            4'b0001: n = 1;
            4'b0010: n = 0;
            4'b0011: n = 1;
            4'b0100: n = 0;
            4'b0101: n = 1;
            4'b0110: n = 0;
            4'b0111: n = 1;
            4'b1000: n = 0;
            4'b1001: n = 1;
            4'b1010: n = 0;
            4'b1011: n = 1;
            4'b1100: n = 0;
            4'b1101: n = 1;
            4'b1110: n = 0;
            4'b1111: n = 1;
            default: n = 0; // Default case
        endcase
    end
endmodule