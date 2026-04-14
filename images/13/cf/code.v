module LDO_Controller(
    input wire [7:0] Vin,       // Input Voltage
    input wire [7:0] Vref,      // Reference Voltage
    input wire enable,          // Enable signal
    output reg control_signal    // Control signal for the pass transistor
);
    always @(*) begin
        if (enable) begin
            if (Vin > Vref) begin
                control_signal = 1; // Turn on the pass transistor
            end else begin
                control_signal = 0; // Turn off the pass transistor
            end
        end else begin
            control_signal = 0; // If not enabled, turn off
        end
    end
endmodule