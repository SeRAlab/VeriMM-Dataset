module restoring_divider(
    input clk,
    input rst,
    input start,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done,
    output reg error
);
    reg [7:0] temp_dividend;
    reg [7:0] temp_divisor;
    reg [3:0] count;
    reg [7:0] current_quotient;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 0;
            error <= 0;
            count <= 4'b0;
            current_quotient <= 8'b0;
        end else if (start) begin
            if (divisor == 8'b0) begin
                error <= 1;
                done <= 1;
            end else begin
                temp_dividend <= dividend;
                temp_divisor <= divisor;
                current_quotient <= 8'b0;
                count <= 4'b100; // Start with 8 iterations
                done <= 0;
                error <= 0;
            end
        end else if (count > 0) begin
            temp_dividend <= {temp_dividend[6:0], 1'b0}; // Shift left
            current_quotient <= {current_quotient[6:0], 1'b0}; // Shift left
            if (temp_dividend >= temp_divisor) begin
                temp_dividend <= temp_dividend - temp_divisor; // Subtract divisor
                current_quotient[0] <= 1; // Set the LSB of quotient
            end
            count <= count - 1;
        end else if (count == 0) begin
            quotient <= current_quotient;
            remainder <= temp_dividend;
            done <= 1;
        end
    end
endmodule