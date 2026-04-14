module sha256_simple (
    input clk,
    input rst,
    input [511:0] message,
    input start,
    output reg [255:0] hash,
    output reg done
);
    reg [255:0] h [0:7]; // Hash values
    reg [511:0] data;
    reg [4:0] round; // Round counter

    initial begin
        h[0] = 32'h6a09e667;
        h[1] = 32'hbb67ae85;
        h[2] = 32'h3c6ef372;
        h[3] = 32'ha54ff53a;
        h[4] = 32'h510e527f;
        h[5] = 32'h9b05688c;
        h[6] = 32'h1f83d9ab;
        h[7] = 32'h5be0cd19;
        round = 0;
        done = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            round <= 0;
            done <= 0;
            hash <= 0;
        end else if (start) begin
            data <= message;
            round <= 0;
            done <= 0;
        end else if (round < 20) begin
            // Simplified process:
            // Here you would implement the SHA-256 round transformation
            // For this example, we simply modify the hash value
            h[0] <= h[0] + data[round*32 +: 32]; // Sample operation
            round <= round + 1;
        end else if (round == 20) begin
            // Finalize the hash output
            hash <= h[0] ^ h[1] ^ h[2] ^ h[3] ^ h[4] ^ h[5] ^ h[6] ^ h[7]; // Example output
            done <= 1;
        end
    end
endmodule