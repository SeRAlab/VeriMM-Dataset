module divider_4bit(
    input clk,
    input rst,
    input start,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] temp_dividend;
    reg [3:0] temp_quotient;
    reg [2:0] state;

    localparam IDLE = 3'b000,
               DIVIDE = 3'b001,
               DONE = 3'b010;

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
                        temp_dividend <= dividend;
                        temp_quotient <= 4'b0000;
                        remainder <= dividend;
                        state <= DIVIDE;
                    end
                end
                DIVIDE: begin
                    if (remainder >= divisor) begin
                        remainder <= remainder - divisor;
                        temp_quotient <= temp_quotient + 1;
                    end else begin
                        quotient <= temp_quotient;
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