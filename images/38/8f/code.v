module rsa_encrypt (
    input wire clk,
    input wire rst,
    input wire [31:0] plaintext,
    input wire [63:0] n,
    input wire [7:0] e,
    output reg [63:0] ciphertext,
    output reg done
);
    reg [63:0] result;
    reg [63:0] base;
    reg [7:0] exponent;
    reg [63:0] mod;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 0;
            base <= plaintext;
            exponent <= e;
            mod <= n;
            done <= 0;
        end else if (exponent > 0) begin
            if (exponent[0] == 1) begin
                result <= (result * base) % mod;
            end
            base <= (base * base) % mod;
            exponent <= exponent >> 1;
        end else begin
            ciphertext <= result;
            done <= 1;
        end
    end
endmodule