module pll (
    input wire clk_in,   // Input clock
    input wire rst,      // Reset signal
    output reg clk_out   // Output clock
);
    reg [3:0] counter; // 4-bit counter for divide and multiply
    reg [1:0] state;   // State for the PLL (0: locked, 1: adjusting, 2: unlocked)

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
            state <= 2; // Start in unlocked state
        end else begin
            if (state == 2) begin
                // Adjusting phase
                counter <= counter + 1;
                if (counter == 4) begin
                    clk_out <= ~clk_out; // Toggle output clock
                    state <= 0; // Go to locked state
                end
            end else if (state == 0) begin
                // Locked state
                counter <= 0; // Reset counter
            end
        end
    end
endmodule