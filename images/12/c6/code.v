module rsa_encryption (
    input [15:0] plaintext,
    input [15:0] exponent,
    input [15:0] modulus,
    output reg [31:0] ciphertext,
    input clk,
    input reset
);
    
    reg [31:0] result;
    reg [15:0] temp_plaintext;
    reg [15:0] temp_exponent;
    reg [15:0] temp_modulus;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ciphertext <= 32'b0;
            result <= 32'b1;
        end else begin
            temp_plaintext <= plaintext;
            temp_exponent <= exponent;
            temp_modulus <= modulus;
            result <= 1;
            for (i = 0; i < 16; i = i + 1) begin
                if (temp_exponent[i]) begin
                    result <= (result * temp_plaintext) % temp_modulus;
                end
                temp_plaintext <= (temp_plaintext * temp_plaintext) % temp_modulus;
            end
            ciphertext <= result;
        end
    end
endmodule