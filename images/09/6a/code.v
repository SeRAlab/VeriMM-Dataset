module aes_8bit (
    input wire clk,
    input wire rst,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);
    reg [7:0] round_key;

    // Simple key expansion (for one round)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            round_key <= 8'b0;
            ciphertext <= 8'b0;
        end else begin
            // Key expansion (simple XOR for demonstration)
            round_key <= key ^ 8'h1B; // Example transformation
            
            // AES round (basic XOR for demonstration)
            ciphertext <= plaintext ^ round_key; // Example transformation
        end
    end
endmodule