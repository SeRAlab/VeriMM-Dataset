module restoring_divider (
    input clk,
    input rst,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] current_dividend;
    reg [3:0] count;
    reg state; // 0: idle, 1: processing

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            current_dividend <= 0;
            count <= 0;
            done <= 0;
            state <= 0;
        end
        else begin
            case (state)
                0: begin // idle state
                    if (divisor != 0) begin
                        current_dividend <= dividend;
                        count <= 8;
                        quotient <= 0;
                        state <= 1; // go to processing state
                    end
                end
                1: begin // processing state
                    current_dividend = current_dividend << 1; // shift left
                    if (quotient < divisor) begin
                        current_dividend = current_dividend | 1'b1; // add 1
                    end
                    quotient = quotient << 1; // shift quotient left
                    if (current_dividend >= divisor) begin
                        current_dividend = current_dividend - divisor;
                        quotient = quotient | 1'b1; // add 1 to quotient
                    end
                    if (count == 0) begin
                        remainder <= current_dividend; // set remainder
                        done <= 1;
                        state <= 0; // go back to idle
                    end
                    count <= count - 1;
                end
            endcase
        end
    end
endmodule