module restoring_divider(
    input clk,
    input reset,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] temp_dividend;
    reg [7:0] temp_divisor;
    reg [3:0] count;
    reg state;

    parameter IDLE = 1'b0, DIVIDE = 1'b1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            temp_dividend <= 8'b0;
            temp_divisor <= 8'b0;
            count <= 4'b0;
            done <= 1'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (divisor != 0) begin
                        temp_dividend <= dividend;
                        temp_divisor <= divisor;
                        quotient <= 8'b0;
                        count <= 4'd8;
                        state <= DIVIDE;
                        done <= 1'b0;
                    end else begin
                        done <= 1'b1; // Division by zero, signal done
                    end
                end

                DIVIDE: begin
                    temp_dividend <= {temp_dividend[6:0], 1'b0}; // Shift left
                    quotient <= {quotient[6:0], 1'b0}; // Shift left quotient
                    temp_dividend <= temp_dividend - temp_divisor; // Subtract divisor
                    
                    if (temp_dividend[7] == 1'b0) begin // If result is non-negative
                        quotient[0] <= 1'b1; // Set least significant bit of quotient
                    end else begin
                        temp_dividend <= temp_dividend + temp_divisor; // Restore
                    end
                    
                    count <= count - 1;
                    if (count == 0) begin
                        remainder <= temp_dividend;
                        done <= 1'b1;
                        state <= IDLE; // Return to idle state
                    end
                end
            endcase
        end
    end
endmodule