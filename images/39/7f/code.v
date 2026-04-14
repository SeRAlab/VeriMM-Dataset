module fractional_n_pll (
    input wire clk_ref,        // Reference clock input
    input wire [7:0] frac_ratio, // Fractional ratio input
    input wire reset,          // Active high reset
    output reg clk_out         // Output clock
);

reg [7:0] counter;            // Counter for clock cycles
reg [7:0] target_count;       // Target count for fractional multiplication
reg clk_div;                  // Divided clock signal

always @(posedge clk_ref or posedge reset) begin
    if (reset) begin
        counter <= 0;
        clk_out <= 0;
    end else begin
        // Increment counter
        counter <= counter + 1;

        // Calculate target count based on fractional ratio
        target_count <= frac_ratio; // Assuming frac_ratio is directly used.

        // Generate output clock based on target count
        if (counter >= target_count) begin
            clk_div <= ~clk_div;    // Toggle divided clock
            counter <= 0;           // Reset counter
        end
        
        clk_out <= clk_div;         // Assign divided clock to output
    end
end

endmodule