module restoring_divider (
    input [7:0] dividend,
    input [7:0] divisor,
    input start,
    input clk,
    input reset,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] temp_dividend;
    reg [7:0] temp_quotient;
    reg [3:0] count;
    reg state;

    localparam IDLE = 1'b0;
    localparam DIVIDE = 1'b1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 8'd0;
            remainder <= 8'd0;
            done <= 1'b0;
            state <= IDLE;
            count <= 4'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        if (divisor == 8'd0) begin
                            // Handle division by zero
                            quotient <= 8'd0;
                            remainder <= dividend;
                            done <= 1'b1;
                        end else begin
                            temp_dividend <= dividend;
                            temp_quotient <= 8'd0;
                            count <= 4'd8; // 8 bits to process
                            state <= DIVIDE;
                            done <= 1'b0;
                        end
                    end
                end
                DIVIDE: begin
                    if (count > 0) begin
                        temp_quotient <= temp_quotient << 1; // Shift left
                        temp_quotient[0] <= 1'b1; // Set the least significant bit
                        temp_dividend <= temp_dividend - divisor;
                        if (temp_dividend[7]) begin // If the result is negative
                            temp_dividend <= temp_dividend + divisor; // Restore
                        end else begin
                            temp_quotient[0] <= 1'b0; // Clear the bit if we subtracted
                        end
                        count <= count - 1;
                    end else begin
                        quotient <= temp_quotient;
                        remainder <= temp_dividend;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule