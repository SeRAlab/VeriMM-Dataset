module restoring_divider (
    input clk,
    input rst,
    input [3:0] dividend,
    input [1:0] divisor,
    output reg [3:0] quotient,
    output reg [1:0] remainder,
    output reg done
);
    reg [4:0] temp_dividend;
    reg [1:0] temp_divisor;
    reg [2:0] count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 4'b0;
            remainder <= 2'b0;
            temp_dividend <= 5'b0;
            temp_divisor <= 2'b0;
            count <= 3'b0;
            done <= 0;
        end else begin
            if (count < 4) begin
                if (count == 0) begin
                    temp_dividend <= {1'b0, dividend}; // Load dividend
                    temp_divisor <= divisor; // Load divisor
                end
                // Shift left the temp_dividend
                temp_dividend <= {temp_dividend[3:0], 1'b0};
                quotient <= {quotient[2:0], 1'b0}; // Shift quotient left
                
                // Subtract divisor from temp_dividend
                if (temp_dividend[4:2] >= {1'b0, temp_divisor}) begin
                    temp_dividend[4:2] <= temp_dividend[4:2] - {1'b0, temp_divisor};
                    quotient[0] <= 1'b1; // Set the LSB of the quotient
                end else begin
                    // Restore the temp_dividend
                    temp_dividend[4:2] <= temp_dividend[4:2] + {1'b0, temp_divisor};
                end
                
                // Increment count
                count <= count + 1;
            end else if (count == 4) begin
                remainder <= temp_dividend[4:3]; // Final remainder
                done <= 1; // Indicate done
            end
        end
    end
endmodule