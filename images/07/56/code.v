module aes_8bit(
    input wire clk,
    input wire rst,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);
    // Internal states
    reg [7:0] round_key;
    reg [7:0] state;

    // Key expansion (not fully AES-compliant, for simplicity)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            round_key <= key; // Reset key
            state <= 8'h00;   // Reset state
            ciphertext <= 8'h00; // Reset output
        end else begin
            round_key <= key ^ 8'h1B; // Simple key transformation for rounds
            state <= plaintext ^ round_key; // Simplified encryption logic
            ciphertext <= state; // Output ciphertext
        end
    end
endmodule