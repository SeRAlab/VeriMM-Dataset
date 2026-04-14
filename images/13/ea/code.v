module clock_divider (
    input wire clk,          // Input clock
    input wire enable,       // Enable signal
    output reg clk_out       // Output clock
);
    reg [1:0] counter;       // 2-bit counter for division

    always @(posedge clk) begin
        if (enable) begin
            counter <= counter + 1; // Increment counter
            if (counter == 2'b01) begin
                clk_out <= ~clk_out; // Toggle output clock
            end
        end else begin
            clk_out <= 0; // Keep output low when not enabled
            counter <= 0;  // Reset counter
        end
    end
endmodule