module top_module( 
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo,
    output wire parity );wire [7:0] in_lo = in[7:0];
    wire [7:0] in_hi = in[15:8];
    wire [7:0] out_lo_parity;
    wire [7:0] out_lo_no_parity;

    // Even parity bit calculation
    wire [7:0] parity_bits;
    wire parity_bit;
    wire [7:0] xor_result;

    assign parity_bits = {in_lo, in_hi} ^ 8'hFF;
    assign xor_result = {parity_bits[0], parity_bits[2], parity_bits[4], parity_bits[6], 4'b0000} ^ 5'b10101;
    assign parity_bit = ~^xor_result;

    // Byte splitter circuit
    assign out_lo_parity = {in_lo, parity_bit};
    assign out_lo_no_parity = in_lo;

    // Multiplexer and decoder for output selection
    assign out_lo = out_lo_no_parity;
    assign out_hi = in_hi;

    // Output even parity bit
    assign parity = parity_bit;

endmodule