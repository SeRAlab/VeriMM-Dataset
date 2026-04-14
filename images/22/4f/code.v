module aes_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);
    reg [7:0] state;
    
    // Simplified AES operation for demonstration
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 8'b0;
            ciphertext <= 8'b0;
        end else begin
            // Substitute bytes and simple XOR with the key
            state <= plaintext ^ key;
            ciphertext <= state; // In real AES, more operations would happen here
        end
    end
endmodule