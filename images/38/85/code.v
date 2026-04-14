module rsa_encrypt (
    input clk,
    input rst,
    input [7:0] message,
    input start,
    output reg [15:0] ciphertext,
    output reg done
);
    parameter e = 3; // Public exponent
    parameter n = 33; // Modulus (for simplicity, should be a product of two primes)

    reg [7:0] msg_reg;
    reg [3:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            ciphertext <= 0;
            done <= 0;
        end else begin
            case (state)
                0: if (start) begin
                    msg_reg <= message;
                    state <= 1;
                end
                1: begin
                    ciphertext <= (msg_reg ** e) % n; // RSA encryption operation
                    state <= 2;
                end
                2: begin
                    done <= 1;
                    state <= 0; // Go back to initial state
                end
            endcase
        end
    end
endmodule