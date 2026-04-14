module rsa_encryption(
    input wire clk,
    input wire reset,
    input wire [15:0] plaintext,  // 16-bit plaintext input
    input wire [15:0] exponent,    // 16-bit exponent (public key)
    input wire [15:0] modulus,     // 16-bit modulus
    output reg [15:0] ciphertext,   // 16-bit ciphertext output
    output reg done                 // Signal indicating encryption is complete
);
    reg [15:0] result;
    reg [15:0] exp_temp;
    reg [15:0] base;
    reg [3:0] state; // State variable for FSM

    localparam IDLE = 4'b0000, 
               CALCULATE = 4'b0001, 
               DONE = 4'b0010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            result <= 16'd1;
            exp_temp <= exponent;
            base <= plaintext;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (exponent != 16'd0) begin
                        state <= CALCULATE;
                    end else begin
                        ciphertext <= 16'd0;
                        done <= 1;
                    end
                end
                CALCULATE: begin
                    if (exp_temp[0] == 1) begin
                        result <= (result * base) % modulus; // Multiply and mod by modulus
                    end
                    base <= (base * base) % modulus; // Square the base
                    exp_temp <= exp_temp >> 1; // Shift exponent right
                    if (exp_temp == 16'd0) begin
                        ciphertext <= result;
                        state <= DONE;
                    end
                end
                DONE: begin
                    done <= 1; // Signal completion
                    state <= IDLE; // Ready for next operation
                end
            endcase
        end
    end
endmodule