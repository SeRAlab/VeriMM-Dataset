module checksum_generator(
    input [3:0] data_in,
    output reg checksum_out
);
    always @(*) begin
        checksum_out = ^data_in; // Parity bit (XOR reduction)
    end
endmodule