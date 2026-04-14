module rsa_encrypt (
    input clk,
    input rst,
    input [7:0] plaintext,
    input [11:0] exponent,
    input [11:0] modulus,
    output reg [11:0] ciphertext
);
    reg [11:0] result;
    reg [11:0] base;
    reg [11:0] exp;
    reg [11:0] mod_tmp;
    reg [3:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 12'b0;
            result <= 12'b1;
            base <= plaintext;
            exp <= exponent;
            mod_tmp <= modulus;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (exp == 0) begin
                        ciphertext <= result % mod_tmp;
                        state <= 5; // Next state for finish
                    end else begin
                        if (exp[0] == 1) begin
                            result <= (result * base) % mod_tmp;
                        end
                        base <= (base * base) % mod_tmp;
                        exp <= exp >> 1; // Divide exponent by 2
                        state <= 1;
                    end
                end
                1: state <= 0; // Go back to main loop
                5: state <= 5; // Finish state
            endcase
        end
    end
endmodule