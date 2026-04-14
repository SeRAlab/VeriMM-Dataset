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
    reg [7:0] temp_quotient;

    localparam IDLE = 4'b0000,
               DIVIDE = 4'b0001,
               DONE = 4'b0010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            quotient <= 8'b0;
            remainder <= 8'b0;
            temp_dividend <= 8'b0;
            temp_quotient <= 8'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= DIVIDE;
                        temp_dividend <= dividend;
                        temp_quotient <= 8'b0;
                        done <= 1'b0;
                    end
                end
                DIVIDE: begin
                    if (temp_dividend >= divisor) begin
                        temp_dividend <= temp_dividend - divisor;
                        temp_quotient <= temp_quotient + 1;
                    end else begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    quotient <= temp_quotient;
                    remainder <= temp_dividend;
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule