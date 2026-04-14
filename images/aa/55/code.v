module custom_logic (
    input m,
    input n,
    input o,
    input p,
    output reg flag);

    always @(*) begin
        case ({m, n, o, p})
            4'b1111: flag = 1;
            4'b0010: flag = 0;
            4'b1101: flag = 0;
            4'b0100: flag = 1;
            4'b1010: flag = 1;
            4'b0110: flag = 0;
            4'b1001: flag = 0;
            4'b0001: flag = 1;
            4'b1100: flag = 1;
            4'b0111: flag = 0;
            default: flag = 0;
        endcase
    end
endmodule