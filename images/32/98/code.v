module restoring_divider(
    input clk,
    input start,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] temp_dividend;
    reg [3:0] temp_remainder;
    reg [2:0] count; // to count clock cycles

    always @(posedge clk or posedge start) begin
        if (start) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            temp_dividend <= dividend;
            temp_remainder <= 4'b0000;
            count <= 3'b100; // Start with 4 bits
            done <= 0;
        end else if (count > 0) begin
            temp_remainder <= {temp_remainder[2:0], temp_dividend[3]};
            temp_dividend <= {temp_dividend[2:0], 1'b0};
            if (temp_remainder >= divisor) begin
                temp_remainder <= temp_remainder - divisor;
                quotient <= {quotient[2:0], 1'b1};
            end else begin
                quotient <= {quotient[2:0], 1'b0};
            end
            count <= count - 1;
        end else begin
            remainder <= temp_remainder;
            done <= 1;
        end
    end
endmodule