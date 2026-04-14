module divider_2bit (
    input clk,
    input reset,
    input enable,
    input [1:0] dividend,
    input [1:0] divisor,
    output reg [1:0] quotient,
    output reg remainder,
    output reg done
);
    reg [1:0] state;
    reg [2:0] count;

    localparam IDLE = 2'b00, DIVIDE = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            quotient <= 2'b00;
            remainder <= 1'b0;
            count <= 3'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (enable) begin
                        if (divisor != 2'b00) begin
                            quotient <= 2'b00;
                            remainder <= dividend;
                            count <= 3'b10; // Start with dividend
                            state <= DIVIDE;
                            done <= 1'b0;
                        end else begin
                            // Handle divide by zero if needed
                            done <= 1'b1;
                        end
                    end
                end
                DIVIDE: begin
                    if (count > 0) begin
                        if (remainder >= divisor) begin
                            remainder <= remainder - divisor;
                            quotient <= quotient + 1;
                        end
                        count <= count - 1;
                    end else begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    done <= 1'b1;
                end
            endcase
        end
    end
endmodule