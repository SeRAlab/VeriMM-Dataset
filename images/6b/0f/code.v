module custom_logic (
    input k,
    input l,
    input m,
    input n,
    output reg control);

    always @(*) begin
        case ({k, l, m, n})
            4'b1101: control = 0;
            4'b0010: control = 1;
            4'b1011: control = 1;
            4'b0100: control = 0;
            4'b1110: control = 1;
            4'b0111: control = 0;
            4'b1001: control = 1;
            4'b0001: control = 0;
            4'b1111: control = 1;
            4'b0110: control = 0;
            default: control = 0;
        endcase
    end
endmodule