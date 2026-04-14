module sha256 (
    input wire clk,
    input wire rst,
    input wire [511:0] message,
    input wire start,
    output reg [255:0] hash,
    output reg ready
);
    reg [255:0] h [0:7]; // SHA-256 hash values
    reg [511:0] m;       // Message
    integer i;
    
    initial begin
        h[0] = 32'h6a09e667;
        h[1] = 32'hbb67ae85;
        h[2] = 32'h3c6ef372;
        h[3] = 32'ha54ff53a;
        h[4] = 32'h510e527f;
        h[5] = 32'h9b05688c;
        h[6] = 32'h1f83d9ab;
        h[7] = 32'h5be0cd19;
        ready = 1'b0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hash <= 256'b0;
            ready <= 1'b0;
        end else if (start) begin
            m <= message;
            // Perform SHA-256 computation here (simplified)
            for (i = 0; i < 64; i = i + 1) begin
                // Update hash values (this is a simplified placeholder)
                h[0] <= h[0] + m[i*8 +: 8]; // Example of using message
            end
            // Final hash assignment
            hash <= h[0] ^ h[1] ^ h[2] ^ h[3] ^ h[4] ^ h[5] ^ h[6] ^ h[7];
            ready <= 1'b1;
        end
    end
endmodule