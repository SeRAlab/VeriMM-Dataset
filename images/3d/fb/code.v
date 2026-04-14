module sha256_block_processor (
    input clk,
    input rst,
    input [511:0] message,
    input valid,
    output reg [255:0] hash,
    output reg ready
);
    // Constants and initial hash values
    reg [255:0] h0, h1, h2, h3, h4, h5, h6, h7;
    
    // Simplified SHA-256 operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize hash values on reset
            h0 <= 32'h6a09e667;
            h1 <= 32'hbb67ae85;
            h2 <= 32'h3c6ef372;
            h3 <= 32'ha54ff53a;
            h4 <= 32'h510e527f;
            h5 <= 32'h9b05688c;
            h6 <= 32'h1f83d9ab;
            h7 <= 32'h5be0cd19;
            hash <= 256'b0;
            ready <= 1'b0;
        end else if (valid) begin
            // Perform dummy SHA-256 computation (for simulation purposes)
            // This is a placeholder for the actual hashing logic
            hash <= h0 ^ h1 ^ h2 ^ h3 ^ h4 ^ h5 ^ h6 ^ h7 ^ message[255:0];
            ready <= 1'b1;
        end
    end
endmodule