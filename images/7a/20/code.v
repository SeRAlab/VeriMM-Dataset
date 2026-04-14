module top_module (
    input a_in,
    input b_in,
    input c_in,
    input d_in,
    output reg c_out);always @* begin
    case ({a_in, b_in, c_in, d_in})
        4'b0110: c_out = 1;
        4'b1001: c_out = 1;
        4'b0000: c_out = 0;
        4'b1111: c_out = 1;
        4'b1010: c_out = 0;
        4'b0101: c_out = 0;
        4'b1101: c_out = 1;
        4'b0011: c_out = 1;
        default: c_out = 0;
    endcase
end
endmodule