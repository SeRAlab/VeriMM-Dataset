module top_module(
    input wire clk,
    input wire reset,
    input wire [7:0] binary_num,
    output reg is_divisible_by_5,
    output reg [3:0] count_ones,
    output reg is_perfect_cube
);

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            is_divisible_by_5 <= 0;
            count_ones <= 0;
            is_perfect_cube <= 0;
        end else begin
            // Check if divisible by 5
            is_divisible_by_5 <= (binary_num % 5 == 0);

            // Count number of 1s
            count_ones <= 0;
            for (i = 0; i < 8; i = i + 1) begin
                if (binary_num[i]) begin
                    count_ones <= count_ones + 1;
                end
            end

            // Check if perfect cube
            is_perfect_cube <= (binary_num == 0 || binary_num == 1 || binary_num == 8 || binary_num == 27 || binary_num == 64);
        end
    end

endmodule