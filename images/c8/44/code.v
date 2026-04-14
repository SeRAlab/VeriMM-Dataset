module combine_bytes( 
    input wire [7:0] in_hi,
    input wire [7:0] in_lo,
    output wire [15:0] out );

    assign out = {in_hi, in_lo};  // Concatenate the two input bytes into a half-word

endmodule