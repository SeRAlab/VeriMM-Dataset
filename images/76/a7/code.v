module top_module(
    input wire clk,
    input wire reset,
    input wire [3:0] binary_num,
    output reg is_gte8,
    output reg [2:0] count_zeros,
    output reg is_power_of_two
);

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            is_gte8 <= 0;
            count_zeros <= 0;
            is_power_of_two <= 0;
        end else begin
            // Check if greater than or equal to 8
            is_gte8 <= (binary_num >= 4'b1000);

            // Count number of 0s
            count_zeros <= 0;
            for (i = 0; i < 4; i = i + 1) begin
                if (!binary_num[i]) begin
                    count_zeros <= count_zeros + 1;
                end
            end

            // Check if power of 2
            is_power_of_two <= (binary_num & (binary_num - 1)) == 0 && binary_num != 0;
        end
    end

endmodule