module vco (
    input wire clk,               // System Clock
    input wire [2:0] control_voltage, // 3-bit control voltage input
    output reg vco_out           // Output of the VCO
);
    reg [25:0] counter;          // Counter for frequency division
    reg [25:0] period;           // Calculated period based on control voltage

    always @(posedge clk) begin
        // Calculate period based on control voltage
        period <= 2 ** control_voltage * 10; // Period in ns

        // Increment counter
        counter <= counter + 1;

        // Toggle output based on the period
        if (counter >= period) begin
            vco_out <= ~vco_out; // Toggle output
            counter <= 0;        // Reset counter
        end
    end
endmodule