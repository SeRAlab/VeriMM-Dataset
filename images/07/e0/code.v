module divider (
    input [3:0] dividend,
    input [3:0] divisor,
    input clk,
    input rst,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] count;
    reg [3:0] temp_dividend;
    reg [3:0] temp_quotient;
    reg is_dividing;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            count <= 0;
            temp_dividend <= 0;
            temp_quotient <= 0;
            is_dividing <= 0;
            done <= 0;
        end else begin
            if (!is_dividing) begin
                // Initiate division
                if (divisor != 0) begin
                    temp_dividend <= dividend;
                    temp_quotient <= 0;
                    count <= 4; // Start with 4 bits
                    is_dividing <= 1;
                    done <= 0;
                end else begin
                    // Handle division by zero
                    quotient <= 4'b0000;
                    remainder <= dividend;
                    done <= 1;
                end
            end else if (count > 0) begin
                // Shift left and subtract
                temp_quotient <= {temp_quotient[2:0], temp_dividend[3]};
                temp_dividend <= {temp_dividend[2:0], 1'b0};

                if (temp_dividend >= divisor) begin
                    temp_dividend <= temp_dividend - divisor;
                    temp_quotient[0] <= 1;
                end else begin
                    temp_quotient[0] <= 0;
                end

                count <= count - 1;
            end else begin
                // Final results
                quotient <= temp_quotient;
                remainder <= temp_dividend;
                done <= 1;
                is_dividing <= 0;
            end
        end
    end
endmodule