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
    reg [7:0] temp_dividend;
    reg [7:0] temp_divisor;
    reg [4:0] count; // To keep track of bit positions
    reg state; // 0: idle, 1: dividing

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 0;
            state <= 0;
            count <= 0;
        end else if (start && !state) begin
            // Initialize for division
            temp_dividend <= dividend;
            temp_divisor <= divisor;
            quotient <= 8'b0;
            remainder <= 8'b0;
            count <= 8; // Start with the highest bit
            state <= 1; // Set state to dividing
            done <= 0;
        end else if (state) begin
            if (count > 0) begin
                remainder <= {remainder[6:0], temp_dividend[7]};
                temp_dividend <= {temp_dividend[6:0], 1'b0}; // Shift dividend
                if (remainder >= temp_divisor) begin
                    remainder <= remainder - temp_divisor; // Subtract divisor
                    quotient <= {quotient[6:0], 1'b1}; // Set quotient bit
                end else begin
                    quotient <= {quotient[6:0], 1'b0}; // Clear quotient bit
                end
                count <= count - 1; // Move to the next bit
            end else begin
                done <= 1; // Division done
                state <= 0; // Return to idle state
            end
        end
    end
endmodule