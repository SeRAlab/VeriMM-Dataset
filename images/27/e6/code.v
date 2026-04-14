module aes_encrypt (
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);

    // Simple S-Box for substitution
    reg [7:0] s_box [0:255];
    
    initial begin
        // Initialize S-Box (a simple example, not a real AES S-Box)
        s_box[8'h00] = 8'h63; s_box[8'h01] = 8'h7c; s_box[8'h02] = 8'h77; // ... Fill all values
        // (For brevity, not filling the entire S-Box)
        s_box[8'hff] = 8'h16; // Example value
    end

    always @(plaintext or key) begin
        // Simple encryption: substitute using S-Box and XOR with key
        ciphertext = s_box[plaintext] ^ key;
    end
endmodule