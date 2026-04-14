module pll (
    input wire clk_in,             // Input clock
    input wire reset,              // Reset signal
    input wire [3:0] div_ratio,    // Division ratio (1 to 15)
    output reg clk_out             // Output clock
);
    reg [3:0] counter;             // Counter for division
    reg clk_div;                   // Divided clock

    // Divide the input clock by the division ratio
    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_div <= 0;
        end else begin
            if (counter < div_ratio - 1) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;
                clk_div <= ~clk_div; // Toggle the divided clock
            end
        end
    end

    // Assign the output clock to the divided clock
    always @(posedge clk_in) begin
        clk_out <= clk_div;
    end
endmodule