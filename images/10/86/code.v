module restoring_divider (
    input clk,
    input rst,
    input start,
    input [5:0] dividend,
    input [2:0] divisor,
    output reg [5:0] quotient,
    output reg [5:0] remainder,
    output reg done
);
    reg [5:0] temp_dividend;
    reg [3:0] count;
    reg [5:0] temp_quotient;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 6'b0;
            remainder <= 6'b0;
            temp_dividend <= 6'b0;
            temp_quotient <= 6'b0;
            count <= 4'b0;
            done <= 0;
        end else if (start) begin
            temp_dividend <= dividend;
            temp_quotient <= 6'b0;
            count <= 4'b0;
            done <= 0;
        end else if (count < 6) begin
            temp_quotient <= {temp_quotient[4:0], 1'b0}; // Shift left quotient
            temp_dividend <= {temp_dividend[4:0], 1'b0}; // Shift left dividend
            
            if (temp_dividend >= {3'b0, divisor}) begin
                temp_dividend <= temp_dividend - {3'b0, divisor}; // Subtract divisor
                temp_quotient[0] <= 1'b1; // Set least significant bit
            end
            
            count <= count + 1;
        end else begin
            quotient <= temp_quotient;
            remainder <= temp_dividend;
            done <= 1;
        end
    end
endmodule