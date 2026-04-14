module temperature_shutdown (
    input wire clk,
    input wire rst,
    input wire [7:0] temperature,  // 8-bit temperature input
    output reg shutdown_signal       // output shutdown signal
);
    parameter TEMP_THRESHOLD = 8'd75; // shutdown threshold
    parameter DELAY_CYCLES = 8'd10;    // delay before shutdown

    reg [7:0] count;  // Counter for the delay
    reg temp_exceeded; // Flag to indicate if temperature exceeds threshold

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shutdown_signal <= 0;
            count <= 0;
            temp_exceeded <= 0;
        end else begin
            if (temperature > TEMP_THRESHOLD) begin
                temp_exceeded <= 1;
                if (count < DELAY_CYCLES) begin
                    count <= count + 1;
                end else begin
                    shutdown_signal <= 1; // Trigger shutdown after delay
                end
            end else begin
                temp_exceeded <= 0;
                count <= 0; // Reset count if temperature is normal
                shutdown_signal <= 0; // Ensure shutdown is off
            end
        end
    end
endmodule