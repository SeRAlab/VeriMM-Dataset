module simple_DES (
    input wire [63:0] plaintext,
    input wire [63:0] key,
    output reg [63:0] ciphertext,
    input wire clk,
    input wire rst
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 64'b0;
        end else begin
            // A simple example operation: XOR the plaintext with the key
            ciphertext <= plaintext ^ key;
        end
    end
endmodule