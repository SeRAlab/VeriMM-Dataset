module watchdog_timer (
    input wire clk,
    input wire enable,
    input wire reset,
    output reg timeout
);

parameter MAX_COUNT = 5; // Set the maximum count for the timer
reg [2:0] count; // 3-bit counter to hold the count value

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 0; // Reset the count to 0
        timeout <= 0; // Clear the timeout signal
    end else if (enable) begin
        if (count < MAX_COUNT) begin
            count <= count + 1; // Increment the count
            timeout <= 0; // Clear the timeout signal
        end else begin
            timeout <= 1; // Set the timeout signal
        end
    end
end

endmodule