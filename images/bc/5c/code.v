module top_module(
    input wire clk,
    input wire reset,
    input wire [3:0] binary_num,
    output reg is_gte10,
    output reg [2:0] count_ones,
    output reg is_perfect_square
);

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            is_gte10 <= 0;
            count_ones <= 0;
            is_perfect_square <= 0;
        end else begin
            // Check if greater than or equal to 10
            is_gte10 <= (binary_num >= 10);

            // Count number of 1s
            count_ones <= 0;
            for (i = 0; i < 4; i = i + 1) begin
                if (binary_num[i]) begin
                    count_ones <= count_ones + 1;
                end
            end

            // Check if perfect square
            is_perfect_square <= (binary_num == 0 || binary_num == 1 || binary_num == 4 || binary_num == 9);
        end
    end

endmodule