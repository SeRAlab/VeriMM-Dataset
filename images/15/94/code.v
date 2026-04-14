module rsa_encrypt (
    input clk,
    input rst_n,
    input [15:0] plaintext,
    input [7:0] public_exponent,
    input [15:0] modulus,
    output reg [15:0] ciphertext,
    output reg ready
);
    reg [15:0] result;
    reg [3:0] count;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ciphertext <= 16'b0;
            ready <= 0;
            count <= 0;
            result <= 1; // Initialize to 1 for multiplication
        end else begin
            if (count < public_exponent) begin
                result <= (result * plaintext) % modulus;
                count <= count + 1;
            end else begin
                ciphertext <= result;
                ready <= 1; // Signal that encryption is complete
            end
        end
    end
endmodule