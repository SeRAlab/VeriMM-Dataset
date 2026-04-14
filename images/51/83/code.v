module top_module(
    input wire clk,
    input wire reset,
    input wire [3:0] binary_num,
    output reg is_lte4,
    output reg [2:0] count_ones,
    output reg is_prime
);

    integer i;
    reg [3:0] num;

    always @(posedge clk) begin
        if (reset) begin
            is_lte4 <= 0;
            count_ones <= 0;
            is_prime <= 0;
        end else begin
            // Check if less than or equal to 4
            is_lte4 <= (binary_num <= 4);

            // Count number of 1s
            count_ones <= 0;
            for (i = 0; i < 4; i = i + 1) begin
                if (binary_num[i]) begin
                    count_ones <= count_ones + 1;
                end
            end

            // Check if prime number
            num = binary_num;
            is_prime <= (num == 2 || num == 3 || num == 5 || num == 7 || num == 11 || num == 13);
        end
    end

endmodule