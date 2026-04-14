module top_module(
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo );// Decoder to select the high byte
    wire [1:0] select_hi;
    assign select_hi = in[15:14];

    // Decoder to select the low byte
    wire [1:0] select_lo;
    assign select_lo = in[13:12];

    // Multiplexer to select the high byte
    wire [7:0] hi_byte;
    assign hi_byte = {in[15:8], 8'b0};
    assign out_hi = hi_byte[select_hi];

    // Multiplexer to select the low byte
    wire [7:0] lo_byte;
    assign lo_byte = {8'b0, in[7:0]};
    assign out_lo = lo_byte[select_lo];

endmodule