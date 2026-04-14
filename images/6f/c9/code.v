module top_module(
    input wire clk,
    input wire reset,
    input wire [4:0] binary_num,
    output reg is_lte10,
    output reg [3:0] count_zeros,
    output reg is_perfect_square
);

    integer i;
    reg [4:0] num;

    always @(posedge clk) begin
        if (reset) begin
            is_lte10 <= 0;
            count_zeros <= 0;
            is_perfect_square <= 0;
        end else begin
            // Check if less than or equal to 10
            is_lte10 <= (binary_num <= 10);

            // Count number of 0s
            count_zeros <= 0;
            for (i = 0; i < 5; i = i + 1) begin
                if (!binary_num[i]) begin
                    count_zeros <= count_zeros + 1;
                end
            end

            // Check if perfect square
            num = binary_num;
            is_perfect_square <= (num == 1 || num == 4 || num == 9 || num == 16);
        end
    end

endmodule