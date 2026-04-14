module PLL_8x(
    input wire clk_ref,     // Reference clock input
    input wire rst,         // Active high reset
    output reg clk_out      // Output clock
);
    reg [2:0] counter;      // 3-bit counter for division
    always @(posedge clk_ref or posedge rst) begin
        if (rst) begin
            clk_out <= 1'b0;
            counter <= 3'b000;
        end else begin
            counter <= counter + 1;
            if (counter == 3'b111) begin
                clk_out <= ~clk_out;  // Toggle output clock every 8 cycles
                counter <= 3'b000;     // Reset counter
            end
        end
    end
endmodule