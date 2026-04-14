module restoring_divider (
    input [3:0] dividend,
    input [3:0] divisor,
    input start,
    input clk,
    input rst,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] current_dividend;
    reg [2:0] count;
    reg [3:0] temp_remainder;
    reg state;

    parameter IDLE = 1'b0, DIVIDING = 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            current_dividend <= 4'b0000;
            count <= 3'b000;
            done <= 1'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        current_dividend <= dividend;
                        temp_remainder <= dividend;
                        quotient <= 4'b0000;
                        count <= 3'b000;
                        state <= DIVIDING;
                    end
                end
                DIVIDING: begin
                    if (count < 4) begin
                        temp_remainder = temp_remainder - divisor;
                        if (temp_remainder >= 0) begin
                            quotient[count] <= 1'b1;
                            remainder <= temp_remainder;
                        end else begin
                            quotient[count] <= 1'b0;
                            temp_remainder = temp_remainder + divisor;
                        end
                        count <= count + 1;
                    end else begin
                        remainder <= temp_remainder;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule