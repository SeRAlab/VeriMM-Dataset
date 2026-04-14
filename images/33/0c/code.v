module rsa_encrypt (
    input clk,
    input reset,
    input [15:0] plaintext,
    input [4:0] exponent,
    input [15:0] modulus,
    output reg [15:0] ciphertext,
    output reg done
);
    reg [15:0] result;
    reg [3:0] count;
    reg [15:0] base;
    reg [15:0] exp;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ciphertext <= 16'b0;
            done <= 0;
            count <= 0;
            result <= 1;
            base <= plaintext;
            exp <= exponent;
        end else begin
            if (count < 16) begin
                if (exp[count]) begin
                    result <= (result * base) % modulus;
                end
                base <= (base * base) % modulus;
                count <= count + 1;
            end else begin
                ciphertext <= result;
                done <= 1;
            end
        end
    end
endmodule