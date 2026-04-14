module rc_oscillator (
    input wire clk,         // Clock input
    input wire enable,      // Enable signal
    output reg out         // Oscillator output
);

parameter HIGH_TIME = 5;   // Number of clock cycles for high state
parameter LOW_TIME = 5;    // Number of clock cycles for low state

reg [3:0] counter;          // 4-bit counter

always @(posedge clk) begin
    if (enable) begin
        if (counter < HIGH_TIME - 1) begin
            out <= 1;
            counter <= counter + 1;
        end else if (counter < HIGH_TIME + LOW_TIME - 1) begin
            out <= 0;
            counter <= counter + 1;
        end else begin
            counter <= 0;  // Reset counter after full cycle
        end
    end else begin
        out <= 0;  // If disabled, output is low
        counter <= 0;  // Reset counter
    end
end

endmodule