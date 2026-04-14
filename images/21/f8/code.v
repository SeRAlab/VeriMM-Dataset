module WatchdogTimer (
    input wire clk,           // Clock input
    input wire reset,         // Reset input
    input wire enable,        // Enable input
    input wire [7:0] limit,   // Limit value
    output reg timeout        // Timeout output signal
);
    reg [7:0] counter;        // 8-bit counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 8'b0;   // Reset counter
            timeout <= 1'b0;   // Reset timeout signal
        end else if (enable) begin
            if (counter < limit) begin
                counter <= counter + 1; // Increment counter
                timeout <= 1'b0;         // No timeout yet
            end else begin
                timeout <= 1'b1;         // Timeout occurred
            end
        end
    end
endmodule