module rsa_encrypt (
    input wire clk,
    input wire reset,
    input wire [63:0] plaintext,
    input wire [63:0] e,      // Public exponent
    input wire [63:0] n,      // Modulus
    output reg [63:0] ciphertext
);
    // Internal registers
    reg [63:0] result;
    reg [63:0] base;
    reg [63:0] exp;
    reg [63:0] mod;
    
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ciphertext <= 64'b0;
            result <= 64'b1;
            base <= plaintext;
            exp <= e;
            mod <= n;
        end else begin
            result <= 1;
            base <= plaintext;
            exp <= e;
            mod <= n;

            for (i = 0; i < 64; i = i + 1) begin
                if (exp[i] == 1) begin
                    result <= (result * base) % mod;
                end
                base <= (base * base) % mod;
            end
            ciphertext <= result;
        end
    end
endmodule