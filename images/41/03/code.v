module non_restoring_divider(
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
    reg state; // 0: idle, 1: dividing

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            temp_dividend <= 8'b0;
            temp_divisor <= 8'b0;
            count <= 4'b0;
            done <= 1'b0;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // idle state
                    if (dividend != 0 && divisor != 0) begin
                        temp_dividend <= dividend;
                        temp_divisor <= divisor;
                        quotient <= 8'b0;
                        remainder <= 8'b0;
                        count <= 4'b0;
                        state <= 1'b1; // move to dividing state
                    end
                end
                
                1'b1: begin // dividing state
                    if (count < 8) begin
                        temp_dividend <= {temp_dividend[6:0], 1'b0}; // Shift left
                        if (temp_dividend >= temp_divisor) begin
                            temp_dividend <= temp_dividend - temp_divisor; // Subtract
                            quotient <= {quotient[6:0], 1'b1}; // Set quotient bit
                        end else begin
                            quotient <= {quotient[6:0], 1'b0}; // Clear quotient bit
                        end
                        count <= count + 1;
                    end else begin
                        remainder <= temp_dividend; // Final remainder
                        done <= 1'b1; // Division is done
                        state <= 1'b0; // Go back to idle
                    end
                end
            endcase
        end
    end
endmodule