module top_module(
    input clk,
    input [3:0] bin,
    output reg [3:0] gray,
    output reg valid
);reg [3:0] prev_gray;

    always@(posedge clk) begin
        // Set valid to 0 by default
        valid <= 0;

        // Calculate MSB of gray
        gray[3] <= bin[3];

        // Calculate remaining bits of gray
        gray[2] <= bin[3] ^ bin[2];
        gray[1] <= bin[2] ^ bin[1];
        gray[0] <= bin[1] ^ bin[0];

        // Check if gray has changed from previous cycle
        if (gray != prev_gray) begin
            valid <= 1;
        end

        // Store current gray as previous gray
        prev_gray <= gray;
    end

endmodule