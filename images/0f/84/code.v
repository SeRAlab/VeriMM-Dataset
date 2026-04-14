module non_restoring_divider(
    input clk,
    input rst,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [4:0] temp_dividend; // Extend size for operations
    reg [3:0] temp_quotient;
    integer count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            done <= 0;
            count <= 0;
        end else if (count < 4) begin
            if (count == 0) begin
                temp_dividend <= {1'b0, dividend}; // Load dividend
                temp_quotient <= 4'b0000; // Initialize quotient
            end else begin
                temp_dividend <= {temp_dividend[3:0], 1'b0}; // Shift left
                if (temp_dividend[4:1] >= divisor) begin
                    temp_dividend[4:1] = temp_dividend[4:1] - divisor; // Subtract divisor
                    temp_quotient = {temp_quotient[2:0], 1'b1}; // Set bit in quotient
                end else begin
                    temp_quotient = {temp_quotient[2:0], 1'b0}; // Clear bit in quotient
                end
            end
            count <= count + 1;
        end else begin
            quotient <= temp_quotient; // Final quotient
            remainder <= temp_dividend[4:1]; // Final remainder
            done <= 1; // Indicate done
        end
    end
endmodule