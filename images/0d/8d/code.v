module aes_encrypt(
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext,
    input wire clk,
    input wire rst
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 8'b0;
        end else begin
            ciphertext <= plaintext ^ key; // Simple XOR operation for encryption
        end
    end
endmodule