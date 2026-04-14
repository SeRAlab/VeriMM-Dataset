module top_module(
    input wire clk,
    input wire reset,
    input wire [7:0] binary_num,
    output reg is_odd,
    output reg [3:0] count_ones,
    output reg is_multiple_of_three
);

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            is_odd <= 0;
            count_ones <= 0;
            is_multiple_of_three <= 0;
        end else begin
            // Check if odd
            is_odd <= binary_num[0];

            // Count number of 1s
            count_ones <= 0;
            for (i = 0; i < 8; i = i + 1) begin
                if (binary_num[i]) begin
                    count_ones <= count_ones + 1;
                end
            end

            // Check if multiple of 3
            is_multiple_of_three <= (binary_num % 3) == 0;
        end
    end

endmodule