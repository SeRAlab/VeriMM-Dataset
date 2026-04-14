module md5_hash(
    input clk,
    input rst,
    input [511:0] data_in,
    input valid,
    output reg [127:0] hash_out,
    output reg ready
);
    reg [127:0] A, B, C, D;
    reg [31:0] K [0:63];
    reg [31:0] S [0:63];

    initial begin
        // MD5 constants
        K[0] = 32'hd76aa478; K[1] = 32'he8c7b756; K[2] = 32'h242070db; K[3] = 32'hc1bdceee;
        K[4] = 32'hf57c0faf; K[5] = 32'h4787c62a; K[6] = 32'ha8304613; K[7] = 32'hfd469501;
        K[8] = 32'h698098d8; K[9] = 32'h8b44f7af; K[10] = 32'hffff5bb1; K[11] = 32'h895cd7be;
        K[12] = 32'h6ca6351; K[13] = 32'h14292967; K[14] = 32'h27b70a85; K[15] = 32'h4eaa3c70;
        K[16] = 32'h5cb0a9dc; K[17] = 32'h76f988da; K[18] = 32'ha4506ceb; K[19] = 32'hbef9a3f7;
        K[20] = 32'hc67178f2; // Continue for remaining constants...

        // MD5 shift amounts
        S[0] = 7; S[1] = 12; S[2] = 17; S[3] = 22;
        // Continue initializing S for all 64 operations...
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 32'h67452301; // Initial hash values
            B <= 32'hefcdab89;
            C <= 32'h98badcfe;
            D <= 32'h10325476;
            hash_out <= 0;
            ready <= 0;
        end else if (valid) begin
            // Perform MD5 transformations for the first 64 bits of data_in
            // For simplicity, we will just assume one iteration here
            // The actual implementation would loop through the operations
            // A simple example transformation:
            A <= B + ((C & D) | (~C & A)) + data_in[31:0] + K[0];
            // Update hash_out, B, C, D as per MD5 algorithm...
            ready <= 1; // Indicate the output is ready
        end
    end
endmodule