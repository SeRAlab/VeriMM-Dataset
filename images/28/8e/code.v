module fractional_n_pll (
    input wire clk_ref,            // Reference clock input
    input wire [7:0] frac_value,   // Fractional value input
    output reg clk_out             // Output clock
);
    reg [15:0] counter;            // Counter for frequency division
    reg [15:0] frac_counter;       // Counter for fractional part
    reg [15:0] frac_divider;       // Divider for fractional logic
    reg clk_div;                   // Divided clock

    always @(posedge clk_ref) begin
        counter <= counter + 1;
        if (counter >= (1 << frac_value[4:0])) begin
            clk_div <= ~clk_div;           // Toggle divided clock
            counter <= 0;                  // Reset counter
        end
    end

    always @(posedge clk_div) begin
        frac_counter <= frac_counter + 1;
        if (frac_counter >= frac_value) begin
            clk_out <= ~clk_out;            // Generate output clock
            frac_counter <= 0;              // Reset fractional counter
        end
    end
endmodule