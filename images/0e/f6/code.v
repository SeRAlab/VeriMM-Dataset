module divider(
    input clk,
    input reset,
    input start,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);

    reg [3:0] state;
    reg [7:0] temp_dividend;
    reg [7:0] temp_quotient;
    reg [7:0] temp_remainder;
    reg [3:0] count;

    parameter IDLE = 4'b0000;
    parameter DIVIDE = 4'b0001;
    parameter DONE = 4'b0010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            quotient <= 0;
            remainder <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        temp_dividend <= dividend;
                        temp_quotient <= 0;
                        temp_remainder <= dividend;
                        count <= 0;
                        if (divisor == 0) begin
                            quotient <= 0;
                            remainder <= 0;
                            done <= 1;
                        end else begin
                            state <= DIVIDE;
                        end
                    end
                end
                DIVIDE: begin
                    if (count < 8) begin
                        if (temp_remainder >= divisor) begin
                            temp_remainder <= temp_remainder - divisor;
                            temp_quotient <= temp_quotient | (1 << (7 - count));
                        end
                        count <= count + 1;
                    end else begin
                        quotient <= temp_quotient;
                        remainder <= temp_remainder;
                        done <= 1;
                        state <= DONE;
                    end
                end
                DONE: begin
                    if (!start) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase
        end
    end
endmodule