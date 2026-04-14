module fractional_n_pll (
    input wire clk_ref,          // Reference clock input
    input wire [7:0] frac_value, // Fractional value input
    output reg clk_out          // Output clock
);
    reg [31:0] counter;          // Counter for frequency division
    reg [7:0] divider;           // Divider value
    reg [31:0] freq_div;         // Frequency division based on frac_value

    always @(posedge clk_ref) begin
        counter <= counter + 1;
        if (counter >= freq_div) begin
            clk_out <= ~clk_out; // Toggle output clock
            counter <= 0;        // Reset counter
        end
    end

    always @(frac_value) begin
        divider <= frac_value;   // Update divider whenever frac_value changes
        freq_div <= (1 << divider) - 1; // Calculate frequency division
    end
endmodule