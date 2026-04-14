module top_module (
    input w,
    input x,
    input y,
    input z,
    output reg y_out);always @* begin
    case ({w, x, y, z})
        4'b1110: y_out = 1;
        4'b0000: y_out = 0;
        4'b1011: y_out = 0;
        4'b0101: y_out = 1;
        4'b1101: y_out = 1;
        4'b0011: y_out = 0;
        4'b1000: y_out = 1;
        4'b0110: y_out = 0;
        4'b1111: y_out = 1;
        4'b0001: y_out = 0;
        4'b1010: y_out = 0;
        4'b0100: y_out = 1;
        default: y_out = 0;
    endcase
end
endmodule