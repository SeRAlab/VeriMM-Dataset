module Divider(
    input [7:0] dividend,
    input [7:0] divisor,
    input start,
    input clk,
    input reset,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [3:0] state;
    reg [7:0] temp_dividend;
    reg [7:0] temp_divisor;
    reg [7:0] temp_quotient;
    reg [3:0] count;

    localparam IDLE = 4'b0000,
               DIVIDE = 4'b0001,
               DONE = 4'b0010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            quotient <= 0;
            remainder <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        temp_dividend <= dividend;
                        temp_divisor <= divisor;
                        temp_quotient <= 0;
                        count <= 8;
                        state <= DIVIDE;
                        done <= 0;
                    end
                end
                DIVIDE: begin
                    if (count > 0) begin
                        if (temp_dividend >= temp_divisor) begin
                            temp_dividend <= temp_dividend - temp_divisor;
                            temp_quotient <= temp_quotient + 1;
                        end
                        count <= count - 1;
                    end else begin
                        quotient <= temp_quotient;
                        remainder <= temp_dividend;
                        state <= DONE;
                    end
                end
                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule