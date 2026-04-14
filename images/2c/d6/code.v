module restoring_divider(
    input clk,
    input reset,
    input start,
    input [7:0] numerator,
    input [7:0] denominator,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [8:0] temp_numerator;
    reg [8:0] temp_denominator;
    reg [3:0] count;
    reg state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 0;
            count <= 4'b0;
            state <= 0;
            temp_numerator <= 0;
            temp_denominator <= 0;
        end else if (start) begin
            temp_numerator <= {1'b0, numerator}; // Extend numerator
            temp_denominator <= {1'b0, denominator}; // Extend denominator
            quotient <= 8'b0;
            remainder <= 8'b0;
            count <= 4'b100; // 8 iterations
            state <= 1;
            done <= 0;
        end else if (state) begin
            temp_numerator <= {temp_numerator[7:0], 1'b0}; // Shift left
            if (temp_numerator >= temp_denominator) begin
                temp_numerator <= temp_numerator - temp_denominator;
                quotient <= {quotient[6:0], 1'b1}; // Append 1 to quotient
            end else begin
                quotient <= {quotient[6:0], 1'b0}; // Append 0 to quotient
            end
            count <= count - 1;
            if (count == 0) begin
                remainder <= temp_numerator[7:0]; // Final remainder
                done <= 1;
                state <= 0; // End state
            end
        end
    end
endmodule