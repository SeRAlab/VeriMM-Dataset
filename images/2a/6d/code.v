module pll (
    input wire clk_ref,        // Reference clock input
    input wire reset,          // Reset signal
    output reg clk_out         // Output clock
);
    parameter DIV_FACTOR = 4;  // Division factor for output clock
    reg [1:0] div_count;        // Counter for division
    reg clk_div;                // Divided clock signal

    always @(posedge clk_ref or posedge reset) begin
        if (reset) begin
            div_count <= 0;
            clk_div <= 0;
        end else if (div_count == DIV_FACTOR - 1) begin
            clk_div <= ~clk_div;   // Toggle divided clock
            div_count <= 0;        // Reset counter
        end else begin
            div_count <= div_count + 1; // Increment counter
        end
    end

    always @(posedge clk_ref or posedge reset) begin
        if (reset) begin
            clk_out <= 0;
        end else begin
            clk_out <= clk_div;    // Output the divided clock
        end
    end
endmodule