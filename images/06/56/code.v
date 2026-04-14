module clock_divider (
    input clk,         // Input clock
    output reg clk_out // Divided clock output
);
    reg [1:0] count; // 2-bit counter

    always @(posedge clk) begin
        count <= count + 1; // Increment count on each clock edge
        if (count == 3) begin
            clk_out <= ~clk_out; // Toggle output clock every 4 cycles
            count <= 0; // Reset count
        end
    end

    initial begin
        clk_out = 0; // Initialize output clock
        count = 0; // Initialize counter
    end
endmodule