module md5_hash (
    input clk,
    input rst,
    input [511:0] msg_in,
    input msg_valid,
    output reg [127:0] hash_out,
    output reg hash_valid
);
    // MD5 constants
    reg [31:0] A, B, C, D;
    reg [511:0] block;
    
    // Initial values for A, B, C, D
    initial begin
        A = 32'h67452301;
        B = 32'hefcdab89;
        C = 32'h98badcfe;
        D = 32'h10325476;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 32'h67452301;
            B <= 32'hefcdab89;
            C <= 32'h98badcfe;
            D <= 32'h10325476;
            hash_out <= 128'h0;
            hash_valid <= 0;
        end else if (msg_valid) begin
            block <= msg_in;
            // Simplified MD5 processing (not the full algorithm)
            // Normally this should involve multiple rounds and operations
            A <= A + B; // Example operation
            B <= B + C; // Example operation
            C <= C + D; // Example operation
            D <= D + A; // Example operation
            
            hash_out <= {A, B[15:0]};
            hash_valid <= 1;
        end
    end
endmodule