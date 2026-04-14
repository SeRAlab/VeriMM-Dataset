module rc_oscillator (
    input wire clk,            // Clock input
    input wire reset,          // Reset signal
    input wire [7:0] R,        // R value
    input wire [7:0] C,        // C value
    output reg clk_out,        // Oscillator output clock
    output reg clk_div2        // Divided clock output
);
    reg [15:0] counter;
    reg [15:0] threshold;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            threshold <= R * C; // Simulate RC time constant
            if (counter >= threshold) begin
                clk_out <= ~clk_out; // Toggle clock output
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    always @(posedge clk_out) begin
        clk_div2 <= ~clk_div2; // Divide the clock output by 2
    end
endmodule