module top_module (
    input i,
    input j,
    input k,
    input l,
    output reg q);always @* begin
    case ({i, j, k, l})
        4'b0101: q = 1;
        4'b1010: q = 0;
        4'b1100: q = 1;
        4'b0011: q = 0;
        4'b1001: q = 1;
        4'b0110: q = 0;
        4'b1111: q = 1;
        4'b0000: q = 0;
        default: q = 0;
    endcase
end
endmodule