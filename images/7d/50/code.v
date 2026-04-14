module top_module (
    input i0,
    input i1,
    input i2,
    input i3,
    output reg out);always @* begin
    case ({i0, i1, i2, i3})
        4'b0011: out = 1;
        4'b1100: out = 1;
        4'b1010: out = 0;
        4'b0111: out = 0;
        4'b1111: out = 1;
        4'b0000: out = 0;
        4'b1001: out = 1;
        4'b0101: out = 1;
        default: out = 0;
    endcase
end
endmodule