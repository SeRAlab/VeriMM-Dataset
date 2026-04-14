module top_module (
    input a_in,
    input b_in,
    input c_in,
    input d_in,
    output reg y_out);always @* begin
    case ({a_in, b_in, c_in, d_in})
        4'b1100: y_out = 1;
        4'b0011: y_out = 0;
        4'b1111: y_out = 1;
        4'b0000: y_out = 0;
        4'b1010: y_out = 0;
        4'b0101: y_out = 1;
        4'b1110: y_out = 1;
        4'b0010: y_out = 0;
        default: y_out = 0;
    endcase
end
endmodule