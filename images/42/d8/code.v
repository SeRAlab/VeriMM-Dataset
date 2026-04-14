module custom_logic (
    input p,
    input q,
    input r,
    input s,
    output reg result);

    always @(*) begin
        case ({p, q, r, s})
            4'b1001: result = 1;
            4'b0110: result = 0;
            4'b1100: result = 0;
            4'b0011: result = 1;
            4'b1110: result = 1;
            4'b0101: result = 0;
            4'b1011: result = 0;
            4'b0000: result = 1;
            4'b1111: result = 0;
            4'b0111: result = 1;
            default: result = 0;
        endcase
    end
endmodule