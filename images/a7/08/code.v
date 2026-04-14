module top_module(
    input clk,
    input reset,
    input enable,
    output reg [7:0] current_random,
    output reg [15:0] current_sum
);reg [31:0] seed = 1;
    reg [7:0] random_num;
    reg [15:0] sum = 0;

    always @(posedge clk) begin
        if (reset) begin
            seed <= 1;
            sum <= 0;
        end else if (enable) begin
            seed <= seed * 1664525 + 1013904223;
            random_num <= seed[31:24];
            sum <= sum + random_num;
        end
    end

    assign current_random = random_num;
    assign current_sum = sum;

endmodule