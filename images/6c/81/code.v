module custom_logic (
    input b,
    input c,
    input d,
    input e,
    output reg status);

    always @(*) begin
        case ({b, c, d, e})
            4'b1100: status = 1;
            4'b0011: status = 0;
            4'b1010: status = 1;
            4'b0101: status = 0;
            4'b1111: status = 1;
            4'b0000: status = 0;
            4'b1001: status = 0;
            4'b0110: status = 1;
            4'b1101: status = 0;
            4'b0010: status = 1;
            default: status = 0;
        endcase
    end
endmodule