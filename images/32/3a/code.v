module divider_8bit (
    input clk,
    input rst,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] temp_dividend;
    reg [7:0] temp_quotient;
    reg [4:0] count; // To keep track of bit shifts and division count
    reg state; // 0 for idle, 1 for calculating

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done <= 0;
            quotient <= 0;
            remainder <= 0;
            count <= 0;
            temp_dividend <= 0;
            temp_quotient <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Idle state
                    if (divisor != 0) begin
                        temp_dividend <= dividend;
                        temp_quotient <= 0;
                        count <= 8; // We will shift and divide for 8 bits
                        state <= 1; // Move to calculating state
                    end else begin
                        done <= 1; // Division by zero case
                    end
                end
                1: begin // Calculation state
                    if (count > 0) begin
                        // Shift left the quotient
                        temp_quotient <= {temp_quotient[6:0], 1'b0};
                        temp_dividend <= {temp_dividend[6:0], 1'b0};
                        if (temp_dividend >= divisor) begin
                            temp_dividend <= temp_dividend - divisor;
                            temp_quotient[0] <= 1;
                        end
                        count <= count - 1;
                    end else begin
                        quotient <= temp_quotient;
                        remainder <= temp_dividend;
                        done <= 1; // Done with division
                        state <= 0; // Go back to idle
                    end
                end
            endcase
        end
    end
endmodule