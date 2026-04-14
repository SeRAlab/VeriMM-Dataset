module watchdog_timer (
    input clk,
    input reset_n,
    input pet_signal,
    input [3:0] timeout, // Timeout period in clock cycles
    output reg reset_out
);

reg [3:0] counter;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        counter <= 0;
        reset_out <= 0;
    end else begin
        if (pet_signal) begin
            counter <= 0; // Reset the counter when pet signal is received
            reset_out <= 0; // No need to reset the system
        end else if (counter < timeout) begin
            counter <= counter + 1; // Increment the counter
            reset_out <= 0; // No reset yet
        end else begin
            reset_out <= 1; // Output reset signal when timeout is reached
        end
    end
end

endmodule