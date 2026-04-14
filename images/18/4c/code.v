module aes_encrypt(
    input wire clk,
    input wire reset,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);
    reg [7:0] state;
    reg [7:0] round_key;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 8'b0;
            round_key <= key; // Use key directly for one round
            ciphertext <= 8'b0;
        end else begin
            // Simple encryption logic (XOR for demonstration)
            state <= plaintext ^ round_key; // Substitute Bytes (for simplicity)
            ciphertext <= state; // Output the ciphertext
        end
    end
endmodule