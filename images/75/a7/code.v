module top_module (
    input p,
    input q,
    input r,
    input s,
    output reg out);always @* begin
    case ({p, q, r, s})
        4'b1100: out = 1;
        4'b0011: out = 0;
        4'b1111: out = 1;
        4'b0000: out = 0;
        4'b1010: out = 0;
        4'b0101: out = 1;
        4'b1110: out = 1;
        4'b0010: out = 0;
        default: out = 0;
    endcase
end
endmodule