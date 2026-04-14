module top_module (
    input x,
    input y,
    input z,
    input w,
    output reg z_out);always @* begin
    case ({x, y, z, w})
        4'b1001: z_out = 1;
        4'b0110: z_out = 0;
        4'b1111: z_out = 1;
        4'b0000: z_out = 0;
        4'b1101: z_out = 1;
        4'b0101: z_out = 0;
        4'b1010: z_out = 0;
        4'b0011: z_out = 1;
        default: z_out = 0;
    endcase
end
endmodule