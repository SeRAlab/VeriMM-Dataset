module top_module(
    input wire clk,
    input wire reset,
    input wire [7:0] binary_num,
    output reg is_multiple_of_4,
    output reg [3:0] sum_bits,
    output reg is_palindrome
);

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            is_multiple_of_4 <= 0;
            sum_bits <= 0;
            is_palindrome <= 0;
        end else begin
            // Determine if multiple of 4
            is_multiple_of_4 <= (binary_num[1:0] == 2'b00);

            // Calculate sum of bits
            sum_bits <= 0;
            for (i = 0; i < 8; i = i + 1) begin
                if (binary_num[i]) begin
                    sum_bits <= sum_bits + 1;
                end
            end

            // Check if palindrome
            is_palindrome <= (binary_num[7:0] == {binary_num[0], binary_num[1], binary_num[2], binary_num[3], binary_num[4], binary_num[5], binary_num[6], binary_num[7]});
        end
    end

endmodule