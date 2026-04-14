module sha256(
    input clk,
    input rst,
    input [511:0] message,
    input valid,
    output reg [255:0] hash,
    output reg ready
);
    reg [63:0] k [0:63];
    reg [31:0] h [0:7];
    reg [511:0] w [0:63];
    integer i;

    initial begin
        // Initialize constants
        k[0] = 64'h428a2f98d728ae22; // ... fill in the rest of the SHA-256 constants
        // Initialize hash values
        h[0] = 32'h6a09e667; // ... fill in the rest of the initial hash values
        // ...
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hash <= 256'b0;
            ready <= 0;
            // Reset hash values
        end else if (valid) begin
            // Implement SHA-256 processing
            // Schedule the message and compress
            // Update hash values
            // Store final hash in output
            hash <= {h[0], h[1], h[2], h[3], h[4], h[5], h[6], h[7]};
            ready <= 1;
        end
    end
endmodule