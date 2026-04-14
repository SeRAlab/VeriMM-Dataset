module top_module(
    input wire clk,
    input wire reset,
    input wire [3:0] binary_num,
    output reg is_even,
    output reg is_perfect_square,
    output reg [3:0] digit_sum
);

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            is_even <= 0;
            is_perfect_square <= 0;
            digit_sum <= 0;
        end else begin
            // Check if even
            is_even <= (binary_num % 2 == 0);

            // Check if perfect square
            is_perfect_square <= 0;
            for (i = 0; i < 4; i = i + 1) begin
                if (i * i == binary_num) begin
                    is_perfect_square <= 1;
                end
            end

            // Calculate sum of digits
            digit_sum <= (binary_num % 10) + (binary_num / 10);
        end
    end

endmodule