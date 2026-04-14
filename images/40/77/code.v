module PLL (
    input wire clk_in,
    input wire reset,
    input wire [1:0] multiplier, // 00: x1, 01: x2, 10: x4, 11: x8
    output reg clk_out
);
    reg [2:0] count; // Counter for the frequency division

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_out <= 0;
            count <= 0;
        end else begin
            count <= count + 1;
            if (count >= (1 << multiplier)) begin
                clk_out <= ~clk_out; // Toggle output clock
                count <= 0; // Reset count
            end
        end
    end
endmodule