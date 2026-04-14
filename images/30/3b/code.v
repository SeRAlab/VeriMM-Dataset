module current_sensor (
    input wire [7:0] Vin,   // 8-bit input voltage (0 to 255 corresponds to 0V to 5V)
    input wire reset,       // Reset signal
    output reg Vout         // Output signal
);
    always @(*) begin
        if (reset) begin
            Vout = 0;        // Reset output to low
        end else if (Vin > 128) begin // Threshold for 2.5V (assuming 0-5V mapping)
            Vout = 1;        // High if Vin exceeds threshold
        end else begin
            Vout = 0;        // Low otherwise
        end
    end
endmodule