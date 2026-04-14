module aes_8bit (
    input clk,
    input rst,
    input [7:0] plaintext,
    input [7:0] key,
    output reg [7:0] ciphertext
);

reg [7:0] state;
reg [7:0] round_key;

// Simple key expansion for demonstration (not AES-compliant)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 8'b0;
        round_key <= key;
        ciphertext <= 8'b0;
    end else begin
        // Substitution layer (using simple XOR for demonstration)
        state <= plaintext ^ round_key; // Simulating a round operation
        
        // Shift rows and mix columns can be implemented here if needed
        
        // Output the ciphertext after one round
        ciphertext <= state;
    end
end

endmodule