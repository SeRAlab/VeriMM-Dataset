module checksum_generator_checker(
    input [7:0] data_in,
    input data_checksum,
    output checksum_out,
    output is_valid
);
    // Generate checksum (parity bit)
    assign checksum_out = ^data_in; // Even parity
    
    // Check validity of received checksum
    assign is_valid = (checksum_out == data_checksum);
endmodule