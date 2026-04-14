module top_module(
    input wire clk,
    input wire reset,
    input wire [7:0] binary_num,
    output reg is_even,
    output reg [3:0] count_ones,
    output reg is_power_of_2
);

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            is_even <= 0;
            count_ones <= 0;
            is_power_of_2 <= 0;
        end else begin
            // Check if even
            is_even <= ~binary_num[0];

            // Count number of 1s
            count_ones <= 0;
            for (i = 0; i < 8; i = i + 1) begin
                if (binary_num[i]) begin
                    count_ones <= count_ones + 1;
                end
            end

            // Check if power of 2
            is_power_of_2 <= (binary_num != 0) && ((binary_num & (binary_num - 1)) == 0);
        end
    end

endmodule