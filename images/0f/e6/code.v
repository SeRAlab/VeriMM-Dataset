module sha256_hash(
    input wire clk,
    input wire rst,
    input wire [255:0] data_in,
    output reg [255:0] hash_out
);
    // SHA-256 initial hash values (first 32 bits of the fractional parts of the square roots of the first 64 primes)
    reg [255:0] h;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hash_out <= 256'h6a09e667bb67ae8584caa73b2c6e00bf3f27b993f9e5ccbc3c6ef372c18159;
        end else begin
            // For simplicity, we just append the data_in to the hash state
            h <= h + data_in;  // This is not the actual SHA-256 transformation
            hash_out <= h;     // Update the output
        end
    end
endmodule