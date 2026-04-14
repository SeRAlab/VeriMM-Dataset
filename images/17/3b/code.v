module temperature_monitor(
    input wire [4:0] temp_in, // 5-bit temperature input
    input wire enable,         // Enable signal
    input wire reset,          // Reset signal
    output reg alarm           // Alarm output signal
);

    parameter THRESHOLD = 5'b10100; // 20°C in binary (assuming a 0-31 range)

    always @(posedge enable or posedge reset) begin
        if (reset) begin
            alarm <= 0; // Reset alarm
        end else begin
            if (temp_in > THRESHOLD) begin
                alarm <= 1; // Activate alarm
            end else begin
                alarm <= 0; // Deactivate alarm
            end
        end
    end
endmodule