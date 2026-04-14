module hmac_generator (
    input wire clk,
    input wire reset,
    input wire [127:0] key,  // 128-bit key
    input wire [127:0] message, // 128-bit message
    output reg [127:0] hash_output // 128-bit hash output
);
    reg [127:0] key_reg;
    reg [127:0] message_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            key_reg <= 128'b0;
            message_reg <= 128'b0;
            hash_output <= 128'b0;
        end else begin
            key_reg <= key;
            message_reg <= message;
            // Simplified hash computation for demonstration purpose
            hash_output <= key_reg ^ message_reg; // XOR operation as a simple hash
        end
    end
endmodule