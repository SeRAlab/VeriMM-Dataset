module rsa_exponentiation (
    input clk,
    input rst,
    input [7:0] a,
    input [7:0] e,
    input [7:0] n,
    output reg [7:0] result,
    output reg done
);
    reg [7:0] base;
    reg [7:0] exp;
    reg [7:0] mod;
    reg [7:0] res;
    reg [3:0] state;

    parameter IDLE = 0, INIT = 1, CALC = 2, DONE = 3;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            result <= 8'b0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    base <= a;
                    exp <= e;
                    mod <= n;
                    res <= 8'b1;
                    state <= INIT;
                end
                INIT: begin
                    if (exp > 0) begin
                        if (exp[0] == 1) begin
                            res <= (res * base) % mod;
                        end
                        base <= (base * base) % mod;
                        exp <= exp >> 1;
                        state <= CALC;
                    end else begin
                        result <= res;
                        done <= 1;
                        state <= DONE;
                    end
                end
                CALC: begin
                    if (exp == 0) begin
                        result <= res;
                        done <= 1;
                        state <= DONE;
                    end else begin
                        if (exp[0] == 1) begin
                            res <= (res * base) % mod;
                        end
                        base <= (base * base) % mod;
                        exp <= exp >> 1;
                        state <= INIT;
                    end
                end
                DONE: begin
                    done <= 1; // Indicate completion
                end
            endcase
        end
    end
endmodule