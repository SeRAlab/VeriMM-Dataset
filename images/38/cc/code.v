module LDO (
    input wire [7:0] Vin,    // 8-bit input voltage
    input wire enable,       // Enable signal
    output reg [7:0] Vout    // 8-bit output voltage
);
    reg [7:0] target_voltage = 8'd100; // Target regulated voltage
    reg [7:0] error;                    // Error signal

    always @(Vin or enable) begin
        if (enable) begin
            // Simple feedback mechanism
            error = target_voltage - Vin; // Calculate error
            Vout = Vin + error;            // Adjust output based on error
        end else begin
            Vout = 8'd0; // Set output to ground when disabled
        end
    end
endmodule