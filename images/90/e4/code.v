module top_module( 
    input wire [15:0] in,
    input wire select,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo );wire [7:0] in_hi;
    wire [7:0] in_lo;

    // Split the input word into two bytes
    assign in_hi = in[15:8];
    assign in_lo = in[7:0];

    // Multiplexer to select between decoder output and input bytes
    wire [7:0] mux_out;
    assign mux_out = select ? in_hi : in_lo;

    // Decoder to select between input bytes
    wire [7:0] dec_out;
    assign dec_out = select ? in_lo : in_hi;

    // Control logic to select between decoder output and multiplexer output
    assign out_hi = select ? mux_out : dec_out;
    assign out_lo = select ? dec_out : mux_out;

endmodule