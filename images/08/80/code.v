module MD5_Hash (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [511:0] data_in,
    output reg [127:0] hash_out
);
    reg [127:0] A, B, C, D; // MD5 state variables
    reg [63:0] count; // Count of bits processed
    reg [3:0] state; // State machine
    
    // Constants for MD5
    reg [31:0] K[0:63];
    reg [31:0] S[0:63];
    
    initial begin
        // Initialize constants K and S
        // (skipped for brevity, define the values here)
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset state
            A <= 32'h67452301;
            B <= 32'hefcdab89;
            C <= 32'h98badcfe;
            D <= 32'h10325476;
            count <= 0;
            hash_out <= 0;
            state <= 0;
        end else if (enable) begin
            // Process input data and update hash
            // (implement MD5 algorithm steps here)
            // (skipped for brevity)
            hash_out <= {A, B, C, D}; // Output final hash
        end
    end
endmodule