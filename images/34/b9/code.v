module hmac(
    input wire clk,
    input wire reset,
    input wire [7:0] key,       // Fixed key for HMAC
    input wire [7:0] message,   // Input message
    output reg [7:0] hmac       // Output HMAC
);
    reg [7:0] hash;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hmac <= 8'b0;
            hash <= 8'b0;
        end else begin
            // Simple hash function: parity
            hash <= message ^ key;  // XOR operation to generate hash
            hmac <= hash ^ key;     // Generate HMAC by XORing hash with key
        end
    end
endmodule