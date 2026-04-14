module restoring_divider (
    input clk,
    input rst,
    input start,
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder,
    output reg done
);
    reg [15:0] temp_dividend;
    reg [15:0] temp_divisor;
    reg [4:0] count;
    reg [15:0] temp_quotient;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 16'b0;
            remainder <= 16'b0;
            done <= 0;
            count <= 0;
        end else if (start) begin
            temp_dividend <= dividend;
            temp_divisor <= divisor;
            temp_quotient <= 16'b0;
            remainder <= dividend;
            done <= 0;
            count <= 16; // Start with 16 bits
        end else if (count > 0) begin
            remainder <= {remainder[14:0], 1'b0}; // Shift left
            temp_quotient <= {temp_quotient[14:0], 1'b0}; // Shift left
            temp_quotient[0] <= 1'b1; // Set LSB for division
            
            if (remainder >= temp_divisor) begin
                remainder <= remainder - temp_divisor; // Subtract divisor
                temp_quotient[0] <= 1'b1; // Set quotient bit
            end else begin
                temp_quotient[0] <= 1'b0; // Reset quotient bit
            end
            
            quotient <= temp_quotient; // Update quotient
            count <= count - 1; // Decrement count
        end else begin
            done <= 1; // Division complete
        end
    end
endmodule