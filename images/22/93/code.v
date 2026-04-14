module watchdog_timer (
    input clk,             // Clock input
    input reset,           // Reset input
    input enable,          // Enable signal
    input [3:0] timeout,   // Timeout value (4 bits, max 15)
    output reg timeout_out  // Timeout output signal
);
    reg [3:0] counter;      // 4-bit counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            timeout_out <= 0;
        end else if (enable) begin
            if (counter < timeout) begin
                counter <= counter + 1;
                timeout_out <= 0;
            end else begin
                timeout_out <= 1; // Timeout condition
            end
        end
    end
endmodule