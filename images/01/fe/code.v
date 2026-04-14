module non_restoring_divider (
    input clk,
    input start,
    input [7:0] dividend,
    input [3:0] divisor,
    output reg [7:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [7:0] temp_dividend;
    reg [3:0] temp_divisor;
    reg [3:0] count;
    
    always @(posedge clk) begin
        if (start) begin
            temp_dividend <= dividend;
            temp_divisor <= divisor;
            quotient <= 0;
            remainder <= 0;
            count <= 8; // We process the dividend bit by bit
            done <= 0;
        end
        else if (count > 0) begin
            // Shift left quotient and dividend
            quotient <= {quotient[6:0], temp_dividend[7]};
            temp_dividend <= {temp_dividend[6:0], 1'b0};
            
            // Subtract or add as per non-restoring division
            temp_dividend = temp_dividend - {4'b0, temp_divisor};
            if (temp_dividend[7] == 1) begin // If negative, restore
                temp_dividend = temp_dividend + {4'b0, temp_divisor};
                quotient[0] = 0;
            end else begin
                quotient[0] = 1;
            end
            
            count <= count - 1;
        end
        else begin
            remainder <= temp_dividend[3:0]; // Final remainder
            done <= 1; // Division is done
        end
    end
endmodule