module fractional_n_pll (
    input wire clk_ref,             // Reference clock input
    input wire [7:0] fractional,    // Fractional control value
    output reg clk_out              // Output clock
);
    reg [15:0] counter;             // Counter for reference clock cycles
    reg [15:0] cycle_count;         // Counter for output clock cycles
    reg [15:0] fractional_value;     // Actual value based on fractional control

    always @(posedge clk_ref) begin
        counter <= counter + 1;
        fractional_value <= fractional;

        if (counter >= (1 << fractional_value)) begin
            clk_out <= ~clk_out;  // Toggle output clock
            counter <= 0;          // Reset counter
        end
    end
endmodule