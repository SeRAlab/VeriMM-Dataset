module watchdog_timer (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire feed,
    output reg timeout
);
    parameter TIMEOUT_LIMIT = 10; // 10 clock cycles
    reg [3:0] counter; // 4-bit counter to count up to 10

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            timeout <= 0;
        end else if (feed) begin
            counter <= 0; // Reset the counter on feed
            timeout <= 0; // Reset timeout when fed
        end else if (enable) begin
            if (counter < TIMEOUT_LIMIT) begin
                counter <= counter + 1;
                timeout <= 0; // No timeout yet
            end else begin
                timeout <= 1; // Timeout occurred
            end
        end
    end
endmodule