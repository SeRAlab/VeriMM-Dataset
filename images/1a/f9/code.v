module divider (
    input clk,
    input start,
    input [7:0] numerator,
    input [7:0] denominator,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] temp_numerator;
    reg [7:0] temp_denominator;
    reg [3:0] state;
    parameter IDLE = 4'b0000, LOAD = 4'b0001, DIVIDE = 4'b0010, DONE = 4'b0011;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (start) begin
                    if (denominator == 8'b0) begin
                        quotient <= 8'b0;
                        remainder <= numerator; // handle division by zero
                        done <= 1;
                        state <= DONE;
                    end else begin
                        temp_numerator <= numerator;
                        temp_denominator <= denominator;
                        quotient <= 8'b0;
                        remainder <= 8'b0;
                        state <= LOAD;
                    end
                end
            end
            LOAD: begin
                state <= DIVIDE;
            end
            DIVIDE: begin
                if (temp_numerator >= temp_denominator) begin
                    temp_numerator <= temp_numerator - temp_denominator;
                    quotient <= quotient + 1;
                end else begin
                    remainder <= temp_numerator;
                    state <= DONE;
                end
            end
            DONE: begin
                done <= 1;
                state <= IDLE; // reset for the next operation
            end
            default: state <= IDLE;
        endcase
    end
endmodule