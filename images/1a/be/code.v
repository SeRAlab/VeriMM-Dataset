module watchdog_timer (
    input wire clk,           // Clock input
    input wire rst_n,         // Active low reset
    input wire enable,        // Enable to start the timer
    input wire heartbeat,     // Heartbeat signal
    input wire [3:0] timeout, // Configurable timeout value
    output reg reset         // Reset signal output
);
    reg [3:0] counter;       // Counter to track time
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            reset <= 0;
        end else if (enable) begin
            if (heartbeat) begin
                counter <= 0; // Reset counter on heartbeat
                reset <= 0;   // Keep reset low
            end else if (counter >= timeout) begin
                reset <= 1;   // Assert reset if timeout is reached
            end else begin
                counter <= counter + 1; // Increment counter
            end
        end else begin
            reset <= 0; // If not enabled, keep reset low
        end
    end
endmodule