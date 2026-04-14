module divider_4bit (
    input clk,
    input start,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] count;
    reg [3:0] temp_dividend;
    reg [3:0] temp_quotient;
    reg state;

    always @(posedge clk) begin
        if (start) begin
            temp_dividend <= dividend;
            temp_quotient <= 4'b0000;
            remainder <= 4'b0000;
            count <= 4'b0000;
            done <= 0;
            state <= 1; // Start division
        end else if (state) begin
            if (count < 4) begin
                // Shift left the remainder
                remainder <= {remainder[2:0], temp_dividend[3]};
                temp_dividend <= {temp_dividend[2:0], 1'b0};
                if (remainder >= divisor) begin
                    remainder <= remainder - divisor;
                    temp_quotient <= {temp_quotient[2:0], 1'b1};
                end else begin
                    temp_quotient <= {temp_quotient[2:0], 1'b0};
                end
                count <= count + 1;
            end else begin
                quotient <= temp_quotient;
                remainder <= remainder;
                done <= 1; // Division done
                state <= 0; // Stop division
            end
        end
    end
endmodule