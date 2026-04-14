module top_module(
    input wire clk,
    input wire reset,
    input wire [11:0] binary_num,
    output reg is_multiple_of_8,
    output reg [3:0] count_zeros,
    output reg is_palindrome
);

    integer i;
    reg [11:0] reversed_num;

    always @(posedge clk) begin
        if (reset) begin
            is_multiple_of_8 <= 0;
            count_zeros <= 0;
            is_palindrome <= 0;
        end else begin
            // Check if multiple of 8
            is_multiple_of_8 <= (binary_num % 8) == 0;

            // Count number of 0s
            count_zeros <= 0;
            for (i = 0; i < 12; i = i + 1) begin
                if (!binary_num[i]) begin
                    count_zeros <= count_zeros + 1;
                end
            end

            // Check if palindrome
            reversed_num = 0;
            for (i = 0; i < 12; i = i + 1) begin
                reversed_num = reversed_num << 1;
                reversed_num[0] = binary_num[i];
            end
            is_palindrome <= (binary_num == reversed_num);
        end
    end

endmodule