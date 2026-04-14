module rsa_encryption (
    input wire [31:0] plaintext,
    input wire [31:0] exponent,
    input wire [31:0] modulus,
    input wire clk,
    input wire start,
    output reg [31:0] ciphertext,
    output reg done
);
    reg [31:0] result;
    reg [31:0] base;
    reg [31:0] exp;
    reg [31:0] mod;
    reg [4:0] bit_index;

    always @(posedge clk) begin
        if (start) begin
            result <= 1;
            base <= plaintext;
            exp <= exponent;
            mod <= modulus;
            bit_index <= 0;
            done <= 0;
        end else if (bit_index < 32) begin
            if (exp[bit_index]) begin
                result <= (result * base) % mod;
            end
            base <= (base * base) % mod;
            bit_index <= bit_index + 1;
        end else begin
            ciphertext <= result;
            done <= 1;
        end
    end
endmodule