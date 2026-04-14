module rsa_encrypt (
    input clk,
    input reset,
    input [7:0] plaintext,
    input [7:0] exponent,
    input [15:0] modulus,
    output reg [15:0] ciphertext,
    output reg ready
);
    reg [15:0] result;
    reg [3:0] state;
    reg [7:0] base;
    reg [31:0] exp;
    
    parameter IDLE = 0, CALC = 1, DONE = 2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            ciphertext <= 16'b0;
            ready <= 0;
        end else begin
            case (state)
                IDLE: begin
                    base <= plaintext;
                    exp <= {8'b0, exponent}; // Extend exponent to 32 bits
                    result <= 16'b1;
                    state <= CALC;
                end
                
                CALC: begin
                    if (exp > 0) begin
                        if (exp[0] == 1) begin
                            result <= (result * base) % modulus; // Modular multiplication
                        end
                        base <= (base * base) % modulus; // Modular squaring
                        exp <= exp >> 1; // Right shift exponent
                    end else begin
                        ciphertext <= result;
                        ready <= 1;
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    ready <= 1; // Indicate processing is done
                end
            endcase
        end
    end
endmodule