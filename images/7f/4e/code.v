module top_module(
    input wire clk,
    input wire reset,
    input wire [6:0] binary_num,
    output reg is_lte50,
    output reg [3:0] count_zeros,
    output reg is_even
);

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            is_lte50 <= 0;
            count_zeros <= 0;
            is_even <= 0;
        end else begin
            // Check if less than or equal to 50
            is_lte50 <= (binary_num <= 50);

            // Count number of 0s
            count_zeros <= 0;
            for (i = 0; i < 7; i = i + 1) begin
                if (!binary_num[i]) begin
                    count_zeros <= count_zeros + 1;
                end
            end

            // Check if even
            is_even <= ~binary_num[0];
        end
    end

endmodule