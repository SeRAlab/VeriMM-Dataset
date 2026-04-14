module top_module(
    input wire clk,
    input wire reset,
    input wire [3:0] binary_num,
    output reg is_gt6,
    output reg [2:0] count_ones,
    output reg is_multiple_of_5
);

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            is_gt6 <= 0;
            count_ones <= 0;
            is_multiple_of_5 <= 0;
        end else begin
            // Check if greater than 6
            is_gt6 <= (binary_num > 6);

            // Count number of 1s
            count_ones <= 0;
            for (i = 0; i < 4; i = i + 1) begin
                if (binary_num[i]) begin
                    count_ones <= count_ones + 1;
                end
            end

            // Check if multiple of 5
            is_multiple_of_5 <= (binary_num % 5) == 0;
        end
    end

endmodule