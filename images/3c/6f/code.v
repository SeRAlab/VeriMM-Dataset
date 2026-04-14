module RSA_Encrypt (
    input wire clk,
    input wire reset,
    input wire [127:0] plaintext, // 128-bit plaintext input
    input wire [127:0] n,          // 128-bit modulus
    input wire [127:0] e,          // 128-bit exponent
    output reg [127:0] ciphertext, // 128-bit ciphertext output
    output reg done                // signal to indicate completion
);
    reg [127:0] result;
    reg [127:0] base;
    reg [127:0] exponent;
    reg [127:0] mod;
    reg [3:0] state;

    localparam IDLE = 0, CALC = 1, DONE = 2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            result <= 0;
            ciphertext <= 0;
        end else begin
            case (state)
                IDLE: begin
                    base <= plaintext;
                    exponent <= e;
                    mod <= n;
                    state <= CALC;
                    done <= 0;
                end

                CALC: begin
                    if (exponent != 0) begin
                        if (exponent[0] == 1) begin
                            result <= (result * base) % mod; // multiplication
                        end
                        base <= (base * base) % mod; // squaring
                        exponent <= exponent >> 1; // exponent division by 2
                    end else begin
                        ciphertext <= result;
                        state <= DONE;
                    end
                end

                DONE: begin
                    done <= 1;
                end
            endcase
        end
    end
endmodule