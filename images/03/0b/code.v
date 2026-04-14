module aes_8bit (
    input wire clk,
    input wire rst,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);
    // Internal signals
    reg [7:0] state;
    reg [7:0] round_key;

    // Key schedule (simplified for 8-bit AES)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            round_key <= key; // Reset round key
        end else begin
            // (For simplicity, we use the original key as the round key.)
            round_key <= key;
        end
    end

    // AES Encryption process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 8'b0; // Reset state
            ciphertext <= 8'b0; // Reset ciphertext
        end else begin
            // AddRoundKey
            state <= plaintext ^ round_key;

            // SubBytes (simple substitution for demonstration)
            state <= {state[6:0], state[7]}; // Rotate left (simple substitution)

            // MixColumns (not fully implemented, simplified for example)
            state <= {state[1:0], state[7:2]}; // Simple mix operation

            // Final output
            ciphertext <= state;
        end
    end
endmodule