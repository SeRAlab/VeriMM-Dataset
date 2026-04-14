module top_module(
    input wire clk,
    input wire reset,
    input wire [4:0] binary_num,
    output reg is_lt16,
    output reg [2:0] count_zeros,
    output reg is_palindrome
);

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            is_lt16 <= 0;
            count_zeros <= 0;
            is_palindrome <= 0;
        end else begin
            // Check if less than 16
            is_lt16 <= (binary_num < 16);

            // Count number of 0s
            count_zeros <= 0;
            for (i = 0; i < 5; i = i + 1) begin
                if (~binary_num[i]) begin
                    count_zeros <= count_zeros + 1;
                end
            end

            // Check if palindrome
            is_palindrome <= (binary_num[0] == binary_num[4] && binary_num[1] == binary_num[3]);
        end
    end

endmodule