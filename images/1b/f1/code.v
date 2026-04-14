module pll_2x (
    input wire clk_in,    // Input clock signal
    input wire reset,     // Reset signal
    output reg clk_out    // Output clock signal (2x frequency)
);
    
    reg clk_d; // D flip-flop output

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_d <= 0;
            clk_out <= 0;
        end else begin
            clk_d <= ~clk_d; // Toggle D flip-flop output
            clk_out <= clk_d; // Output clock is the same as D flip-flop output
        end
    end

endmodule