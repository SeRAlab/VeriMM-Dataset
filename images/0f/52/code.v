module aes_8bit(
    input wire clk,
    input wire rst,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);
    // Internal registers for the AES algorithm
    reg [7:0] state;
    reg [7:0] round_key;

    // Key expansion (simple example for 8-bit)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            round_key <= key; // Load key on reset
        end else begin
            round_key <= round_key ^ 8'h1B; // Simple key schedule for example
        end
    end

    // Initial round
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 8'd0;
        end else begin
            state <= plaintext ^ round_key; // AddRoundKey operation
        end
    end

    // First round (sub bytes, shift rows, mix columns not included for simplicity)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 8'd0;
        end else begin
            ciphertext <= state; // Output the current state as ciphertext
        end
    end

endmodule