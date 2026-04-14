module LinearVoltageRegulator (
    input wire enable,
    input wire [7:0] input_voltage, // 8-bit input voltage
    output reg [7:0] output_voltage   // 8-bit regulated output voltage
);
    always @(enable or input_voltage) begin
        if (enable) begin
            // Assume the regulated output voltage is fixed at 5V (or 8'h05 in this case)
            output_voltage = 8'h05; 
        end else begin
            output_voltage = 8'h00; // 0V when disabled
        end
    end
endmodule