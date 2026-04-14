module restoring_divider(
    input clk,
    input rst,
    input [3:0] dividend,
    input [1:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] current_dividend;
    reg [3:0] current_quotient;
    reg [2:0] count;
    reg [3:0] sub_result;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            done <= 0;
            count <= 3'b000;
            current_dividend <= dividend;
            current_quotient <= 4'b0000;
        end else if (count < 4) begin
            sub_result = current_dividend - {2'b00, divisor}; // Subtract divisor (with zero padding)
            if (sub_result[3] == 1) begin // If negative result
                current_dividend = current_dividend; // Keep current dividend
            end else begin
                current_dividend = sub_result; // Update current dividend
                current_quotient[count] = 1; // Set quotient bit
            end
            count <= count + 1;
        end else begin
            quotient <= current_quotient;
            remainder <= current_dividend;
            done <= 1; // Indicate division is done
        end
    end
endmodule