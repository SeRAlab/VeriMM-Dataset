module simple_sha256 (
    input wire clk,
    input wire rst,
    input wire [255:0] data_in,
    input wire start,
    output reg [255:0] hash_out,
    output reg done
);
    // Simplified constants and operations for SHA-256
    reg [255:0] hash_state;
    reg [63:0] k [0:63]; // SHA-256 constants
    integer i;

    initial begin
        // Initialize constants (first 64 primes)
        k[0] = 64'h428a2f98d728ae22; k[1] = 64'h7137449123ef65cb; // ... initialize all constants
        // Add more initialization as needed.
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hash_state <= 256'h6a09e667bb67ae8584caa7321ef321d8; // Initial hash value
            done <= 0;
        end else if (start) begin
            // Simplified SHA-256 processing logic
            for (i = 0; i < 64; i = i + 1) begin
                // Perform mixing and hashing operations (simplified)
                // This is a placeholder for SHA-256 transformations.
                hash_state <= hash_state + (data_in ^ k[i]);
            end
            hash_out <= hash_state;
            done <= 1;
        end
    end
endmodule