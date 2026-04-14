module fractional_n_pll (
    input clk,              // Input clock
    input reset,            // Reset signal
    input [9:0] N,          // Frequency divider value
    input [9:0] F,          // Fractional value
    output reg clk_out      // Output clock
);

reg [19:0] counter;          // Counter to create the output clock
reg [19:0] threshold;        // Threshold for toggling the output clock
reg [19:0] fractional_part;  // To store the fractional part
reg [19:0] total_division;   // Total division value

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        clk_out <= 0;
    end else begin
        total_division <= (N << 10) + F;  // Total division with fractional part
        counter <= counter + 1;
        if (counter >= total_division) begin
            clk_out <= ~clk_out; // Toggle clock output
            counter <= 0;        // Reset counter
        end
    end
end

endmodule