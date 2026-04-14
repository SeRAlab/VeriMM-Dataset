module restoring_divider (
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
    reg [7:0] temp_quotient;
    reg [3:0] count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            temp_dividend <= 0;
            temp_quotient <= 0;
            count <= 0;
            done <= 0;
        end else if (start && count == 0) begin
            temp_dividend <= dividend;
            temp_quotient <= 0;
            remainder <= dividend;
            count <= 8; // Assume we are dividing 8 bits
            done <= 0;
        end else if (count > 0) begin
            // Shift left the temp quotient and the remainder
            temp_quotient <= {temp_quotient[6:0], 1'b0};
            remainder <= {remainder[6:0], 1'b0};
            remainder[0] <= temp_dividend[7];
            temp_dividend <= {temp_dividend[6:0], 1'b0};
            
            // Subtract divisor from remainder
            if (remainder >= divisor) begin
                remainder <= remainder - divisor;
                temp_quotient[0] <= 1'b1; // Set the least significant bit of the quotient
            end
            
            count <= count - 1; // Decrement the count
            
            if (count == 1) begin
                quotient <= temp_quotient;
                done <= 1;
            end
        end
    end
endmodule