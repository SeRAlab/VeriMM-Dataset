module top_module (
    input m,
    input n,
    input o,
    input p,
    output reg s);always @* begin
    case ({m, n, o, p})
        4'b1010: s = 0;
        4'b0101: s = 1;
        4'b1111: s = 1;
        4'b0000: s = 0;
        4'b1001: s = 1;
        4'b0110: s = 0;
        4'b1101: s = 1;
        4'b0010: s = 0;
        default: s = 0;
    endcase
end
endmodule