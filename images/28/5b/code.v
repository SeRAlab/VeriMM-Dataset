module md5_hash (
    input wire clk,
    input wire reset,
    input wire [127:0] data_in,
    input wire valid,
    output reg [31:0] hash_out
);
    reg [31:0] hash;
    integer i;

    initial begin
        hash = 32'h67452301; // Initial hash value
        hash_out = 32'b0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hash <= 32'h67452301; // Reset to initial value
            hash_out <= 32'b0;
        end else if (valid) begin
            // Simple hashing process as a placeholder for MD5-like operations
            for (i = 0; i < 4; i = i + 1) begin
                hash = hash ^ data_in[i*32 +: 32]; // XOR with each 32-bit chunk
                hash = hash + (hash << 5); // Bitwise operations to mix the bits
                hash = hash ^ (hash >> 7); // Further mixing
            end
            hash_out <= hash;
        end
    end
endmodule