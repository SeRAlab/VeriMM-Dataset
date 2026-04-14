module top_module(
    input wire clk,
    input wire reset,
    input wire [2:0] binary_num,
    output reg is_gte5,
    output reg [2:0] count_ones,
    output reg is_fibonacci
);

    integer i;
    reg [2:0] num;

    always @(posedge clk) begin
        if (reset) begin
            is_gte5 <= 0;
            count_ones <= 0;
            is_fibonacci <= 0;
        end else begin
            // Check if greater than or equal to 5
            is_gte5 <= (binary_num >= 5);

            // Count number of 1s
            count_ones <= 0;
            for (i = 0; i < 3; i = i + 1) begin
                if (binary_num[i]) begin
                    count_ones <= count_ones + 1;
                end
            end

            // Check if Fibonacci number
            num = binary_num;
            is_fibonacci <= (num == 1 || num == 2 || num == 3 || num == 5);
        end
    end

endmodule