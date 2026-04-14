module rsa_encryption(
    input clk,
    input rst,
    input [9:0] plaintext,
    input [7:0] exponent,
    input [9:0] modulus,
    output reg [9:0] ciphertext
);
    reg [9:0] result;
    reg [7:0] exp;
    reg [9:0] base;
    reg [9:0] mod;
    reg [3:0] state;

    localparam IDLE = 4'b0000,
               COMPUTE = 4'b0001,
               DONE = 4'b0010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            ciphertext <= 10'b0;
            result <= 10'b1;
            exp <= 8'b0;
            base <= plaintext;
            mod <= modulus;
        end else begin
            case (state)
                IDLE: begin
                    exp <= exponent;
                    if (exponent != 0)
                        state <= COMPUTE;
                    else
                        state <= DONE;
                end
                COMPUTE: begin
                    if (exp[0]) 
                        result <= (result * base) % mod;
                    base <= (base * base) % mod;
                    exp <= exp >> 1;
                    if (exp == 0)
                        state <= DONE;
                end
                DONE: begin
                    ciphertext <= result;
                    state <= IDLE; // Reset for next operation
                end
            endcase
        end
    end
endmodule