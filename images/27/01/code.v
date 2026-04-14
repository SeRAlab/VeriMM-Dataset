module aes_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);
    // Simplified AES encryption logic
    reg [7:0] state;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 8'b0;
            ciphertext <= 8'b0;
        end else begin
            // Example operation: XOR with key
            state <= plaintext ^ key;
            // Simulate some transformation (for example, a simple permutation)
            ciphertext <= {state[3:0], state[7:4]};
        end
    end
endmodule