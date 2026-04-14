module rsa_encryption (
    input clk,
    input reset,
    input [15:0] plaintext,
    input [15:0] exponent,
    output reg [15:0] ciphertext,
    output reg done
);
    reg [15:0] base;
    reg [15:0] result;
    reg [15:0] exp;
    reg [3:0] state;

    localparam IDLE = 4'b0000,
               CALC = 4'b0001,
               DONE = 4'b0010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            result <= 16'b0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    base <= plaintext;
                    exp <= exponent;
                    result <= 16'b1;
                    state <= CALC;
                    done <= 0;
                end
                CALC: begin
                    if (exp > 0) begin
                        if (exp[0] == 1) begin
                            result <= (result * base) % 65537;
                        end
                        base <= (base * base) % 65537;
                        exp <= exp >> 1;
                    end else begin
                        ciphertext <= result;
                        state <= DONE;
                    end
                end
                DONE: begin
                    done <= 1;
                    state <= IDLE; // Ready for next operation
                end
            endcase
        end
    end
endmodule