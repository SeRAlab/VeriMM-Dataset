module top_module(
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo );wire [7:0] temp_out_hi;
    wire [7:0] temp_out_lo;

    assign temp_out_hi = in >> 8;
    assign temp_out_lo = in & 8'hFF;

    assign out_hi = temp_out_hi;
    assign out_lo = temp_out_lo;

endmodule