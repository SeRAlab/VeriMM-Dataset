module top_module(
    input wire clk,
    input wire reset,
    input wire [6:0] binary_num,
    output reg is_divisible_by_7,
    output reg [3:0] count_ones,
    output reg is_fibonacci
);

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            is_divisible_by_7 <= 0;
            count_ones <= 0;
            is_fibonacci <= 0;
        end else begin
            // Check if divisible by 7
            is_divisible_by_7 <= (binary_num % 7 == 0);

            // Count number of 1s
            count_ones <= 0;
            for (i = 0; i < 7; i = i + 1) begin
                if (binary_num[i]) begin
                    count_ones <= count_ones + 1;
                end
            end

            // Check if Fibonacci number
            is_fibonacci <= (binary_num == 0 || binary_num == 1 || binary_num == 2 || binary_num == 3 || binary_num == 5 || binary_num == 8 || binary_num == 13 || binary_num == 21 || binary_num == 34 || binary_num == 55);
        end
    end

endmodule