module top_module(
    input wire clk,
    input wire reset,
    input wire [2:0] binary_num,
    output reg is_gte5,
    output reg [1:0] count_ones,
    output reg is_even
);

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            is_gte5 <= 0;
            count_ones <= 0;
            is_even <= 0;
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

            // Check if even
            is_even <= ~binary_num[0];
        end
    end

endmodule