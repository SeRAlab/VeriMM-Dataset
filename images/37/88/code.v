module restoring_divider (
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
    reg [7:0] current_remainder;
    reg [7:0] current_quotient;
    reg [7:0] divisor_temp;
    parameter IDLE = 4'b0000, START = 4'b0001, SUBTRACT = 4'b0010, RESTORE = 4'b0011, SHIFT = 4'b0100, DONE = 4'b0101;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        current_remainder <= dividend;
                        current_quotient <= 8'b0;
                        divisor_temp <= divisor;
                        state <= START;
                        done <= 1'b0;
                    end
                end
                START: begin
                    if (current_remainder >= divisor_temp) begin
                        state <= SUBTRACT;
                    end else begin
                        state <= DONE;
                    end
                end
                SUBTRACT: begin
                    current_remainder <= current_remainder - divisor_temp;
                    current_quotient <= (current_quotient << 1) | 1'b1;
                    state <= SHIFT;
                end
                SHIFT: begin
                    current_quotient <= current_quotient << 1;
                    state <= START;
                end
                DONE: begin
                    quotient <= current_quotient;
                    remainder <= current_remainder;
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule