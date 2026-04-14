module divider(
    input [3:0] numerator,
    input [3:0] denominator,
    input start,
    input clk,
    input rst,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] num;
    reg [3:0] denom;
    reg [4:0] temp_quotient; // 5-bits to handle overflow
    reg [3:0] temp_remainder;
    reg [2:0] state;

    parameter IDLE = 3'b000, CALC = 3'b001, DONE = 3'b010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            done <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        num <= numerator;
                        denom <= denominator;
                        temp_quotient <= 0;
                        temp_remainder <= 0;
                        if (denominator != 0) begin
                            state <= CALC;
                        end else begin
                            quotient <= 4'b0000;
                            remainder <= 4'b0000;
                            done <= 1;
                        end
                    end
                end
                CALC: begin
                    if (num >= denom) begin
                        num <= num - denom;
                        temp_quotient <= temp_quotient + 1;
                    end else begin
                        temp_remainder <= num;
                        quotient <= temp_quotient[3:0];
                        remainder <= temp_remainder;
                        done <= 1;
                        state <= DONE;
                    end
                end
                DONE: begin
                    if (!start) begin
                        done <= 0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule