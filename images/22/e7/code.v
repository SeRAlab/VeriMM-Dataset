module rsa_encrypt (
    input [4:0] plaintext,
    input [2:0] exponent,
    input [4:0] modulus,
    output reg [4:0] ciphertext,
    input clk,
    input rst
);
    reg [4:0] result;
    reg [2:0] exp;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 5'b00000;
            exp <= 3'b000;
            ciphertext <= 5'b00000;
        end else begin
            if (exp == 3'b000) begin
                result <= plaintext;
                exp <= exponent;
            end else if (exp > 0) begin
                result <= (result * plaintext) % modulus;
                exp <= exp - 1;
            end else begin
                ciphertext <= result;
            end
        end
    end
endmodule