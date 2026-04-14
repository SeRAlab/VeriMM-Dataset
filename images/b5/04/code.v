module top_module( 
    input wire [7:0] in_hi,
    input wire [7:0] in_lo,
    output wire [16:0] out );wire parity_bit;
    wire [15:0] half_word;

    // Concatenate the two input bytes into a half-word
    assign half_word = {in_hi, in_lo};

    // Generate parity bit using XOR gate
    assign parity_bit = ^half_word;

    // Append parity bit to half-word output
    assign out = {half_word, parity_bit};

endmodule