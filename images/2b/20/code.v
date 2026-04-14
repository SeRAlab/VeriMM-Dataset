module divider (
    input clk,
    input rst,
    input start,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [3:0] state;
    reg [7:0] temp_dividend;
    reg [7:0] temp_divisor;
    reg [3:0] count;

    parameter IDLE = 4'b0000;
    parameter DIVIDE = 4'b0001;
    parameter DONE = 4'b0010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        temp_dividend <= dividend;
                        temp_divisor <= divisor;
                        quotient <= 8'b0;
                        remainder <= 8'b0;
                        count <= 8;
                        state <= DIVIDE;
                    end
                end
                DIVIDE: begin
                    if (count > 0) begin
                        if (temp_dividend >= temp_divisor) begin
                            temp_dividend <= temp_dividend - temp_divisor;
                            quotient <= quotient + 1;
                        end
                        count <= count - 1;
                    end else begin
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