module aes_8bit(
    input wire clk,
    input wire rst,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);
    reg [7:0] state;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 8'b0;
            ciphertext <= 8'b0;
        end else begin
            // AES-like simple transformation (for example, XOR with key)
            state <= plaintext ^ key;
            ciphertext <= state; // output the transformed state
        end
    end
endmodule