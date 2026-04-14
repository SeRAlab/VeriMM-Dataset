module divider (
    input clk,
    input rst,
    input start,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] divd, divs;
    reg [2:0] state;

    parameter IDLE = 3'b000, LOAD = 3'b001, DIVIDE = 3'b010, DONE = 3'b011;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        divd <= dividend;
                        divs <= divisor;
                        quotient <= 4'b0000;
                        remainder <= 4'b0000;
                        state <= LOAD;
                    end
                end
                LOAD: begin
                    if (divs != 0) begin
                        state <= DIVIDE;
                    end else begin
                        remainder <= divd;
                        done <= 1;
                        state <= DONE;
                    end
                end
                DIVIDE: begin
                    if (divd >= divs) begin
                        divd <= divd - divs;
                        quotient <= quotient + 1;
                    end else begin
                        remainder <= divd;
                        done <= 1;
                        state <= DONE;
                    end
                end
                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule