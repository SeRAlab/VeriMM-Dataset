module aes_8bit(
    input clk,
    input rst,
    input [7:0] plaintext,
    input [7:0] key,
    output reg [7:0] ciphertext
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 8'b0;
        end else begin
            ciphertext <= plaintext ^ key; // Simple XOR encryption
        end
    end
endmodule