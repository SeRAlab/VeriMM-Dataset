module rsa_encrypt(
    input clk,
    input rst,
    input [127:0] plaintext,
    input [63:0] e,
    input [63:0] n,
    output reg [127:0] ciphertext
);
    
    reg [127:0] temp_result;
    reg [63:0] exponent;
    reg [127:0] base;
    reg [127:0] modulus;
    reg [6:0] count; // To count the number of bits in e
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 0;
            base <= 0;
            exponent <= 0;
            modulus <= 0;
            temp_result <= 1; // Initial value for multiplication
            count <= 0;
        end else begin
            if (count < 64) begin
                if (count == 0) begin
                    base <= plaintext;
                    exponent <= e;
                    modulus <= n;
                end
                
                // If the current exponent bit is set
                if (exponent[count]) begin
                    temp_result <= (temp_result * base) % modulus;
                end
                
                // Square the base
                base <= (base * base) % modulus;
                count <= count + 1;
            end else begin
                ciphertext <= temp_result;
            end
        end
    end
endmodule