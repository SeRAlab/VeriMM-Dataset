module watchdog_timer (
    input wire clk,
    input wire reset,
    output reg timeout
);

parameter TIMEOUT = 5; // Timeout period in clock cycles
reg [2:0] counter; // 3-bit counter to count up to TIMEOUT

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        timeout <= 0;
    end else if (counter == TIMEOUT) begin
        timeout <= 1; // Assert timeout
    end else begin
        counter <= counter + 1; // Increment counter
        timeout <= 0; // Deassert timeout
    end
end

endmodule